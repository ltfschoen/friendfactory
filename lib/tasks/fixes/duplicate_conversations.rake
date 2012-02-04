namespace :ff do
  namespace :fix do
    task :duplicate_conversations => :environment do
      ActiveRecord::Base.transaction do
        remove_duplicate_conversations_for(published_conversations)
        remove_duplicate_conversations_for(unpublished_conversations)
        delete_conversations_staged_for_deletion
        commit
      end
    end
  end
end

def remove_duplicate_conversations_for(conversations)
  puts "*" * 30
  conversations.each do |wave|
    check_for_conversation_on_one_site(wave)
    check_for_duplicate_converstions(wave) do |wave, duplicate_waves|
      move_messages_from_duplicate_waves_to_wave(wave, duplicate_waves)
      stage_conversations_for_deletion(duplicate_waves)
    end
  end
end

def published_conversations
  @published_conversations ||= begin
    Wave::Conversation.published.order('`updated_at` DESC').includes(:sites).all
  end
end

def unpublished_conversations
  @unpublished_conversations ||= begin
    Wave::Conversation.unpublished.order('`updated_at` DESC').includes(:sites).all
  end
end

def fixed_conversations
  @fixed_conversations ||= []
end

def fixed_conversation_ids
  fixed_conversations.map(&:id)
end

def conversations_staged_for_deletion
  @conversations_staged_for_deletion ||= []
end

def conversation_ids_staged_for_deletion
  conversations_staged_for_deletion.map(&:id).uniq
end

def extract_site(wave)
  wave.sites.first
end

def duplicate_conversations(wave)
  user_id = wave[:user_id]
  recipient_id = wave[:resource_id]
  site = extract_site(wave)

  relation = Wave::Conversation.joins(:sites).
      where(['`waves`.`id` <> ?', wave[:id]]).
      where(:user_id => user_id, :resource_id => recipient_id).
      where(:sites => { :id => site.id }).scoped

  if fixed_conversation_ids.present?
    relation = relation.where(['`waves`.`id` NOT IN (?)', fixed_conversation_ids]).scoped
  end

  relation.all
end

def check_for_conversation_on_one_site(wave)
  sites = wave.sites
  if sites.length != 1
    puts "conversation:#{wave[:id]} on #{sites.length} sites"
    raise ActiveRecord::Rollback
  end
end

def check_for_duplicate_converstions(wave)
  duplicates = duplicate_conversations(wave)
  if duplicates.present? && block_given?
    yield wave, duplicates
  end
end

def move_messages_from_duplicate_waves_to_wave(wave, duplicate_waves)
  posting_ids = wave.posting_ids.uniq
  duplicate_waves_posting_ids = duplicate_waves.map(&:posting_ids).flatten.uniq
  posting_ids_to_move = duplicate_waves_posting_ids - posting_ids
  puts "conversation:#{wave[:id]} adding #{posting_ids_to_move.length} postings"
  puts "  from conversations: #{duplicate_waves.map(&:id).join(',')}"
  puts "  posting ids: #{posting_ids_to_move.join(',')}"
  if postings_to_move = Posting::Base.find(posting_ids_to_move)
    Wave::Conversation.record_timestamps = false
    wave.postings.push(postings_to_move)
    fixed_conversations << wave
    Wave::Conversation.record_timestamps = true
  end
end

def stage_conversations_for_deletion(waves)
  conversations_staged_for_deletion << waves
  conversations_staged_for_deletion.flatten!
end

def delete_conversations_staged_for_deletion
  puts "destroying conversation ids:#{conversation_ids_staged_for_deletion.join(',')}"
  delete_bookmarks_from_conversations_staged_for_deletion
  remove_conversations_staged_for_deletion_from_sites
  destroy_conversations_staged_for_deletion
end

def delete_bookmarks_from_conversations_staged_for_deletion
  bookmarks = Bookmark.where(:wave_id => conversation_ids_staged_for_deletion).all
  puts "  destroying #{bookmarks.length} bookmarks"
  Bookmark.destroy(bookmarks.map(&:id))
end

def remove_conversations_staged_for_deletion_from_sites
  puts "  removing waves from sites"
  conversations_by_site_id = conversations_staged_for_deletion.group_by { |wave| extract_site(wave).id }
  conversations_by_site_id.each do |site_id, waves|
    Site.find(site_id).waves.delete(waves)
  end
end

def destroy_conversations_staged_for_deletion
  puts "  destroying #{conversation_ids_staged_for_deletion.length} waves"
  Wave::Conversation.destroy(conversation_ids_staged_for_deletion)
end

def commit
  if 'false' == ENV['COMMIT']
    puts "rollback"
    ActiveRecord::Rollback
  else
    puts "commit"
  end
end


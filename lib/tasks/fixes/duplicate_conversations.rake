namespace :ff do
  namespace :fix do
    task :duplicate_conversations => :environment do

      def conversations
        @conversations ||= begin
          Wave::Conversation.order('`updated_at` DESC').includes(:sites).all
        end
      end

      def transaction_without_conversation_timestamps
        Wave::Conversation.record_timestamps = false
        ActiveRecord::Base.transaction { yield }
        Wave::Conversation.record_timestamps = true
      end

      def remove_duplicate_conversations_for(conversations)
        conversations.each do |wave|
          check_for_conversation_on_one_site(wave)
          check_for_duplicate_converstions(wave) do |wave, duplicate_waves|
            move_messages_from_duplicate_waves_to_wave(wave, duplicate_waves)
            stage_conversations_for_deletion(duplicate_waves)
          end
        end
      end

      def fixed_conversations
        @fixed_conversations ||= []
      end

      def fixed_conversation_ids
        fixed_conversations.map(&:id)
      end

      def extract_site(wave)
        wave.sites.first
      end

      def check_for_conversation_on_one_site(wave)
        sites = wave.sites
        if sites.length != 1
          puts "conversation:#{wave[:id]} on #{sites.length} sites"
          raise ActiveRecord::Rollback
        end
      end

      ### Duplicates

      def check_for_duplicate_converstions(wave)
        duplicates = duplicate_conversations(wave)
        if duplicates.present? && block_given?
          yield wave, duplicates
        end
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

      def move_messages_from_duplicate_waves_to_wave(wave, duplicate_waves)
        # Postings won't be pushed to recipient wave
        # since site isn't specified on posting.
        posting_ids = wave.posting_ids.uniq
        duplicate_waves_posting_ids = duplicate_waves.map(&:posting_ids).flatten.uniq
        posting_ids_to_move = duplicate_waves_posting_ids - posting_ids
        puts "conversation:#{wave[:id]} adding #{posting_ids_to_move.length} postings"
        puts "  from conversations: #{duplicate_waves.map(&:id).join(',')}"
        puts "  posting ids: #{posting_ids_to_move.join(',')}"
        if postings_to_move = Posting::Base.find(posting_ids_to_move)
          wave.postings.push(postings_to_move)
          fixed_conversations << wave
        end
      end

      ### Deletion

      def conversations_staged_for_deletion
        @conversations_staged_for_deletion ||= []
      end

      def conversation_ids_staged_for_deletion
        conversations_staged_for_deletion.map(&:id).uniq
      end

      def stage_conversations_for_deletion(waves)
        conversations_staged_for_deletion << waves
        conversations_staged_for_deletion.flatten!
      end

      def delete_conversations_staged_for_deletion
        delete_bookmarks_from_conversations_staged_for_deletion
        remove_conversations_staged_for_deletion_from_sites
        destroy_conversations_staged_for_deletion
      end

      def delete_bookmarks_from_conversations_staged_for_deletion
        bookmarks = Bookmark.where(:wave_id => conversation_ids_staged_for_deletion).all
        puts "destroying #{bookmarks.length} bookmarks"
        Bookmark.destroy(bookmarks.map(&:id))
      end

      def remove_conversations_staged_for_deletion_from_sites
        puts "removing waves from sites"
        conversations_by_site_id = conversations_staged_for_deletion.group_by { |wave| extract_site(wave).id }
        conversations_by_site_id.each do |site_id, waves|
          Site.find(site_id).waves.delete(waves)
        end
      end

      def destroy_conversations_staged_for_deletion
        puts "destroying #{conversation_ids_staged_for_deletion.length} waves"
        puts "  ids:#{conversation_ids_staged_for_deletion.join(',')}"
        Wave::Conversation.destroy(conversation_ids_staged_for_deletion)
      end

      ### Reconciliation

      def reconciled_conversations
        @reconciled_conversations ||= []
      end

      def reconciled_conversation_ids
        reconciled_conversations.map(&:id)
      end

      def reconcile_conversations_postings(waves)
        waves.each do |wave|
          unless reconciled_conversation_ids.include?(wave[:id])
            user = wave.user
            site = extract_site(wave)
            if recipient_wave = wave.recipient.conversation_with(user, site)
              user_posting_ids = wave.posting_ids
              recipient_posting_ids = recipient_wave.posting_ids
              unless arrays_contain_same_elements?(user_posting_ids, recipient_posting_ids)
                reconcile_postings_for(wave, recipient_wave)
                reconcile_postings_for(recipient_wave, wave)
                reconciled_conversations << recipient_wave
              end
            end
          end
        end
      end

      def arrays_contain_same_elements?(array1, array2)
        array1 = array1.sort
        array2 = array2.sort
        ((array1 - array2) == []) && ((array2 - array1) == [])
      end

      def reconcile_postings_for(wave, recipient_wave)
        site = extract_site(wave)
        posting_ids_to_move = wave.posting_ids - recipient_wave.posting_ids
        if move_postings(posting_ids_to_move, :to => recipient_wave)
          puts "reconcile conversation:#{wave[:id]} with recipient wave:#{recipient_wave[:id]}"
          puts "  moved posting ids:#{posting_ids_to_move.join(',')} to recipient:#{recipient_wave[:id]}"
          reset_conversation_postings_count(recipient_wave)
        end
      end

      def move_postings(posting_ids, opts)
        destination_wave = opts[:to]
        if postings_to_move = Posting::Base.find(posting_ids)
          destination_wave.postings.push(postings_to_move)
          postings_to_move.length > 0
        else
          false
        end
      end

      def reset_conversation_postings_count(wave)
        current_postings_count = wave.postings_count
        published_postings_count = wave.postings.published.count
        if current_postings_count != published_postings_count
          puts "  conversation:#{wave[:id]} postings count was:#{current_postings_count} now:#{published_postings_count}"
          wave.postings_count = published_postings_count
          wave.save!
        end
      end

      ### Commit

      def commit
        if 'false' == ENV['COMMIT']
          puts "rollback"
          ActiveRecord::Rollback
        else
          puts "commit"
        end
      end

      transaction_without_conversation_timestamps do
        remove_duplicate_conversations_for(conversations)
        delete_conversations_staged_for_deletion
        reconcile_conversations_postings(conversations)
        commit
      end

    end
  end
end

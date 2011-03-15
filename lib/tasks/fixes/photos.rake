namespace :ff do
  namespace :fix do
    task :posting_photos_to_albums => :environment do
      ActiveRecord::Base.record_timestamps = false
      community_wave.postings.only(Posting::Photo).each do |posting|
        album_wave = create_album_wave(:user_id => posting.user_id, :created_at => posting.created_at, :updated_at => posting.updated_at)
        move_posting(posting, :from => community_wave, :to => album_wave)
        create_wave_proxy(community_wave, :for => album_wave)
      end      
    end
  end
end

def community_wave
  @community_wave ||= Wave::Community.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
end

def create_album_wave(opts)
  @album_wave = Wave::Album.new.tap do |wave|
    wave.user_id = opts[:user_id]
    wave[:created_at] = opts[:created_at]
    wave[:updated_at] = opts[:updated_at]
    wave.state = 'published'
    wave.save!
  end
end

def move_posting(posting, opts)
  opts[:from].postings.delete(posting)
  opts[:to].postings << posting
end

def create_wave_proxy(wave, opts)
  proxy = Posting::WaveProxy.new.tap do |posting|
    posting.user_id = opts[:for].user_id
    posting.resource = opts[:for]
    posting[:created_at] = opts[:for].created_at
    posting[:updated_at] = opts[:for].updated_at
    posting.state = 'published'
    posting.save!
  end
  wave.postings << proxy
end

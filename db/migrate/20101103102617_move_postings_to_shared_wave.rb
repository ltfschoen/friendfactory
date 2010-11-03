class MovePostingsToSharedWave < ActiveRecord::Migration
  def self.up
    say 'ff:db:default_wave'
    Rake::Task[:'ff:db:default_wave'].invoke

    say 'moving postings from profile wave (id=2) to shared wave (id=1)'
    user = User.find_by_email('michael@michaelbamford.com')
    shared_wave = Wave::Base.find_by_slug(WavesController::DefaultWaveSlug)
    
    if user.present? && shared_wave.present?
      profile_posting_ids = user.profile.posting_ids - user.profile.avatar_ids
      shared_wave.posting_ids = (shared_wave.posting_ids + profile_posting_ids).uniq
      user.profile.posting_ids = (user.profile.posting_ids - profile_posting_ids)

      say "moved #{profile_posting_ids.sort * ' '}", true
      say "kept  #{user.profile.posting_ids.sort * ' '}", true
    end
    
    say 'moving avatars from profile waves to shared wave (id=1)'
    moved_ids = []
    Wave::Profile.all.each do |profile|
      unless profile.avatar.nil?
        shared_wave.posting_ids = (shared_wave.posting_ids + [ profile.avatar_id ]).uniq
        moved_ids << profile.avatar_id
      end
    end
    say "moved #{moved_ids * ' '}", true
  end

  def self.down
  end
end

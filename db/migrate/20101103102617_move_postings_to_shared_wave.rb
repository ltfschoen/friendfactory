class MovePostingsToSharedWave < ActiveRecord::Migration
  def self.up
    say 'ff:db:default_wave'
    Rake::Task[:'ff:db:default_wave'].invoke

    user = User.find_by_email('michael@michaelbamford.com')
    shared_wave = Wave::Base.find_by_slug(WavesController::DefaultWaveSlug)
    say "moving postings from profile wave (id=#{user.profile.id}) to shared wave (id=#{shared_wave.id})"
    
    if user.present? && shared_wave.present?
      profile_posting_ids = user.profile.posting_ids - user.profile.avatar_ids
      shared_wave.posting_ids = (shared_wave.posting_ids + profile_posting_ids).uniq
      user.profile.posting_ids = (user.profile.posting_ids - profile_posting_ids)
      say "moved #{profile_posting_ids.sort * ' '}", true
      say "kept  #{user.profile.posting_ids.sort * ' '}", true
    end
    
    say "copying active avatars from all profile waves to shared wave (id=#{shared_wave.id})"
    avatar_ids = Wave::Profile.all.map{ |profile| profile.avatar_id }.compact
    copied_ids = (shared_wave.posting_ids + avatar_ids).uniq - shared_wave.posting_ids
    shared_wave.posting_ids = (shared_wave.posting_ids + avatar_ids).uniq
    say "found  #{avatar_ids.sort * ' '}", true
    say "copied #{copied_ids.sort * ' '}", true
  end

  def self.down
  end
end

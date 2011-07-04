module Wave::ProfilesHelper
  def render_profile_wave_posting(posting)
    posting.class == Posting::Avatar ? render(:partial => 'avatar', :object => posting) : render_posting(posting)
  end
end

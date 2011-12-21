class Wave::Invitation < Wave::Base

  def nine_recent_invitations
    postings.type(Posting::Invitation).order('`postings`.`created_at` DESC').limit(9)
  end

  def self.find_all_by_site_and_fully_offered(site, min_offered = Wave::InvitationsHelper::MaximumDefaultImages)
    select('`waves`.*').
    joins('INNER JOIN `publications` ON `waves`.`id` = `publications`.`wave_id`').
    site(site).
    group('`publications`.`wave_id`').
    having("count(*) >= #{min_offered.to_i}").
    order('count(*) desc').
    all
  end

  def publish_posting_to_waves(posting)
    [ publish_posting_to_personal_wave(posting), publish_posting_to_home_wave(posting) ]
  end

end

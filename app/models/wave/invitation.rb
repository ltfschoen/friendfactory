class Wave::Invitation < Wave::Base

  def self.find_all_by_site_and_fully_offered(site, min_offered = Wave::InvitationsHelper::MaximumDefaultImages)
    select('`waves`.*').
    joins('INNER JOIN `postings_waves` ON `waves`.`id` = `postings_waves`.`wave_id`').
    group('`postings_waves`.`wave_id`').
    having("count(*) >= #{min_offered.to_i}").
    site(site)
  end
  
end

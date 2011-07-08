class Wave::Invitation < Wave::Base

  def self.find_all_by_site_and_fully_offered(site, min_offered = Wave::InvitationsHelper::MaximumDefaultImages)
    select('`waves`.*').
    joins('INNER JOIN `publications` ON `waves`.`id` = `publications`.`wave_id`').
    site(site).
    group('`publications`.`wave_id`').
    having("count(*) >= #{min_offered.to_i}").
    order('count(*) desc').
    all    
  end
  
end

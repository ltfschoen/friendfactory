class UserSession < Authlogic::Session::Base  
  
  InactivityTimeout = 10.minutes
  remember_me_for 4.weeks

  attr_writer :skip_enrollment_validation
  
  validate :enabled?
  validate :enrolled?
  
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  private
  
  def enabled?
    if attempted_record.present? && !attempted_record.enabled?
      errors.add(:base, I18n.t("error_messages.not_enabled", :default => "account is not enabled"))
    end
  end
  
  def enrolled?    
    if !@skip_enrollment_validation && attempted_record.present? && !enrolled_site_ids.include?(controller.current_site.id)
      errors.add(:base, I18n.t("error_messages.not_enrolled", :default => "email is not a member of this site"))
    end
  end
  
  def enrolled_site_ids
    (attempted_record.site_ids << attempted_record.enrollment_site.try(:id)).compact
  end

end

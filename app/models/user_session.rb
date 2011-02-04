class UserSession < Authlogic::Session::Base  
  
  InactivityTimeout = 10.minutes
  remember_me_for 4.weeks

  validate :enabled?
  
  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  private
  
  def enabled?
    return true if attempted_record.nil?
    unless attempted_record.enabled?
      errors.add(:base, I18n.t("error_messages.not_enabled", :default => "Your account is not enabled"))
      false
    end
  end

end

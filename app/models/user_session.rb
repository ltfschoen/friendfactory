class UserSession < Authlogic::Session::Base
  extend ActiveModel::Naming

  generalize_credentials_error_messages "Login and password are invalid"

  InactivityTimeout = 7.minutes
  remember_me_for 4.weeks

  validate :enabled?

  private

  def enabled?
    if attempted_record.present? && attempted_record.disabled?
      errors.add(:base, I18n.t("error_messages.not_enabled", :default => "account is not enabled"))
    end
  end

end

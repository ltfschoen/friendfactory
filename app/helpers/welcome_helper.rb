module WelcomeHelper
  def user_with_default_persona(user)
    unless user.default_personage.present?
      user.build_default_personage.build_persona
    end
    user
  end
end

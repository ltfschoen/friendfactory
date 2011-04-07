class InvitationsMailer < ActionMailer::Base
  
  default :from => "michael@friskyhands.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.invitation.subject
  #

  def new_invitation_mail(invitation)
    @invitation = invitation
    email = Rails.env.production? ? @invitation.email : 'michael@michaelbamford.com'
    mail :to => email, :subject => "Invitation to join #{@invitation.site}"
  end
  
end

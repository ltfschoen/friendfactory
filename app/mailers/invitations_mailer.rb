class InvitationsMailer < ActionMailer::Base
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.invitation.subject
  #

  default :from => "mailer@friskyfactory.com"

  def new_invitation_mail(invitation)
    @invitation = invitation
    email = Rails.env.production? ? @invitation.email : 'michael@michaelbamford.com'
    subject = "Invitation from #{@invitation.sponsor.handle(@invitation.site)} to join #{@invitation.site.display_name}!"
    mail :to => email, :subject => subject
  end
  
end

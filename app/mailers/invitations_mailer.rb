class InvitationsMailer < ApplicationMailer
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #   en.invitations.invitation.subject

  def new_invitation_mail(invitation)
    @invitation = invitation
    @host = host_for_site(@invitation.site)
    subject = "Invitation from #{@invitation.sponsor.handle} to join #{@invitation.site.display_name}!"
    mail :from => @invitation.site.mailer, :to => email_for_environment(@invitation.email), :subject => subject
  end
  
end

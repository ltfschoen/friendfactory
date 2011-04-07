class InvitationsMailer < ActionMailer::Base
  
  # default :from => "michael@friskyhands.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.invitation.subject
  #

  def new_invitation_mail(invitation)
    @invitation = invitation    

    email = case Rails.env
    when 'production' then @invitation.email
    when 'staging'    then @invitation.sponsor.email
    else 'michael@michaelbamford.com'
    end

    mail :to => email, :subject => "Invitation to join #{@invitation.site}"
  end
  
end

class MessagesMailer < ActionMailer::Base

  default :from => "mailer@friskyfactory.com"

  def new_message_notification(message)
    @message = message
    @host = ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', @message.site.name)    
    email = Rails.env.production? ? @message.receiver.email : 'michael@michaelbamford.com'
    subject = "Message from #{@message.sender.handle(@message.site)} at #{@message.site.display_name}"
    mail :to => email, :subject => subject
  end

end

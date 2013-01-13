module Posting
  class MessagesMailer < ApplicationMailer
    layout 'mailer'

    def create(recipient, message, site, host, port)
      super
      mail :from => site_mailer, :to => recipient_email, :subject => subject
    end

  private

    def recipient_email
      email_for_environment(posting.receiver.email, posting.sender.email)
    end

    def subject
      "Message from #{posting.sender.display_handle} at #{site.display_name}"
    end
  end
end


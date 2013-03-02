require "spec_helper"

module Posting
  describe MessagesMailer do

    fixtures :users

    it "renders the headers" do
      pending
      message = mock_model(Posting::Message, :sender => users(:adam), :receiver => users(:bert))
      mail = PostingsMailer.new_message_notification(message)
      mail.should_not be_nil
      mail.subject.should eq "Forgot password"
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      pending
      mail.body.encoded.should match("Hi")
    end
  end
end


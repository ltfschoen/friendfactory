require "spec_helper"

describe UserSessionMailer do
  describe "forgot_password" do
    let(:mail) { UserSessionMailer.forgot_password }

    it "renders the headers" do
      mail.subject.should eq("Forgot password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end

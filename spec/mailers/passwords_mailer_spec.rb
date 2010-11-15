require "spec_helper"

describe PasswordsMailer do
  describe "forgot_password" do
    let(:mail) { PasswordsMailer.reset }

    it "renders the headers" do
      pending
      mail.subject.should eq("Forgot password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      pending
      mail.body.encoded.should match("Hi")
    end
  end

end

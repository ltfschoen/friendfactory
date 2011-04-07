require "spec_helper"

describe InvitationsMailer do
  describe "deliver_invitation_mail" do
    let(:mail) { InvitationsMailer.deliver_invitation_mail }

    it "renders the headers" do
      mail.subject.should eq("Invitation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end

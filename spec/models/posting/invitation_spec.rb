require 'spec_helper'

describe Posting::Invitation do

  describe "reinvitations" do

    fixtures :sites, :users

    let(:today) { DateTime.civil(1968, 3, 21, 1) }

    let(:invitations) { @invitations }

    before(:each) { Date.stub!(:today).and_return(today) }
    
    before(:each) do
      @invitations = 0.upto(9).inject({}) do |memo, age|
        created_at = today - age.day
        invitation = Posting::Invitation.create!(
            :site => sites(:friskyhands),
            :sponsor => users(:adam),
            :body => "invite-#{age}",
            :state => 'offered',
            :created_at => created_at)
        memo[created_at.strftime('%Y%m%d').to_sym] = invitation
        memo
      end
    end

    describe "scopes" do
      it "for 1 day old invitations" do
        Posting::Invitation.days_old(1.day).should == [ invitations[:'19680319'] ]
      end

      it "for 3-day-old invitations" do
        Posting::Invitation.days_old(3.days).should == [ invitations[:'19680317'] ]
      end

      it "for 7-day-old invitations" do
        Posting::Invitation.days_old(7.days).should == [ invitations[:'19680313'] ]
      end

      it "for expiring invitations" do
        Posting::Invitation.expiring.should == [ invitations[:'19680312'] ]
      end
    end

    it "are mailed via the InvitationsMailer" do
      mail_message = mock(Mail::Message).as_null_object
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'19680319']).ordered.and_return(mail_message)
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'19680317']).ordered.and_return(mail_message)
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'19680313']).ordered.and_return(mail_message)
      InvitationsMailer.should_receive(:new_invitation_mail).with(invitations[:'19680312']).ordered.and_return(mail_message)
      Posting::Invitation.redeliver_mail
    end
  end

end

require 'spec_helper'

describe Posting::Invitation do

  describe "scopes" do

    fixtures :sites, :users

    let(:today) { DateTime.civil(1968, 3, 21, 1) }

    let(:invitations) do
      0.upto(9).inject({}) do |memo, age|
        created_at = today - age.day
        invitation = Posting::Invitation.create!(:site => sites(:friskyhands), :sponsor => users(:adam), :body => "invite-#{age}", :created_at => created_at)
        memo[created_at.strftime('%Y%m%d').to_sym] = invitation
        memo
      end
    end

    before(:each) do
      Date.stub!(:today).and_return(today)
    end

    it "shows 1 day old invitations" do
      Posting::Invitation.days_old(1.day).should == [ invitations[:'19680319'] ]
    end

    it "shows 3-day-old invitations" do
      Posting::Invitation.days_old(3.days).should == [ invitations[:'19680317'] ]
    end

    it "shows 7-day-old invitations" do
      Posting::Invitation.days_old(7.days).should == [ invitations[:'19680313'] ]
    end

    it "shows expiring invitations" do
      Posting::Invitation.expiring.should == [ invitations[:'19680312'] ]
    end

  end

end

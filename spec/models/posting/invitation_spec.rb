require 'spec_helper'

describe Posting::Invitation do
  describe "email changed" do
    let(:invitation) { @invitation }
    before(:each) do 
      @invitation = Posting::Invitation.create!(:site => mock_model(Site), :sponsor => mock_model(User), :body => "yack@test.com")
    end
    
    it "doesn't change on first assignment for a new record" do
      invitation.should_not be_email_changed
      invitation.email.should == 'yack@test.com'
    end

    it "does change when assigned new email to email attribute" do
      invitation.update_attribute(:email, 'zed@test.com')
      invitation.should be_email_changed
      invitation.email.should == 'zed@test.com'
    end    

    it "does change when assigned new email to body attribute" do
      invitation.update_attribute(:body, 'zed@test.com')
      invitation.should be_email_changed
      invitation.body.should == 'zed@test.com'
    end    
  end
  
  describe 'scopes' do
    describe 'personal and universal' do
      let(:personal_invitation)  { @personal }
      let(:universal_invitation) { @universal }
      
      before(:each) do
        Posting::Invitation.delete_all        
        @personal = Posting::Invitation.create!(:site => mock_model(Site), :sponsor => mock_model(User), :body => 'zed@test.com')
        @universal = Posting::Invitation.create!(:site => mock_model(Site), :sponsor => mock_model(User), :body => nil)
      end
      
      it "shows personal invitations" do
        Posting::Invitation.personal.should == [ personal_invitation ]
      end

      it "shows universal invitations" do
        Posting::Invitation.universal.should == [ universal_invitation ]
      end      
    end
    
    describe 'days old, aging and expiring' do
      let(:today) { DateTime.civil(2011, 1, 15, 1) }
      let(:invitations) { @invitations }      

      before(:each) do
        Date.stub!(:today).and_return(today)
        Posting::Invitation.stub!(:FIRST_REMINDER_AGE).and_return(1.day)
        Posting::Invitation.stub!(:SECOND_REMINDER_AGE).and_return(7.days)
        Posting::Invitation.stub!(:EXPIRATION_AGE).and_return(10.days)

        Posting::Invitation.delete_all
        @invitations = 0.upto(12).inject({}) do |memo, age|
          created_at = today - age.days
          invitation = Posting::Invitation.create!(
              :site       => mock_model(Site),
              :sponsor    => mock_model(User),
              :body       => "user-#{age}@test.com",
              :state      => 'offered',
              :created_at => created_at)
          memo[created_at.strftime('%Y%m%d').to_sym] = invitation
          memo
        end
      end

      it "for 1 day old invitations" do
        Posting::Invitation.age(1.day).should == [ invitations[:'20110113'] ]
      end

      it "for 7-day-old invitations" do
        Posting::Invitation.age(7.days).should == [ invitations[:'20110107'] ]
      end

      it "for aging invitations" do
        Posting::Invitation.aging.should == [ invitations[:'20110107'], invitations[:'20110113'] ]
      end
    
      it "for expiring invitations" do
        Posting::Invitation.expiring.should == [ invitations[:'20110104'] ]
      end
    end
    
    describe 'redundant and not redundant' do
      fixtures :users      
      let(:redundant_invitation)     { @redundant }
      let(:not_redundant_invitation) { @not_redundant }
      
      before(:each) do
        Posting::Invitation.delete_all
        @redundant = Posting::Invitation.create!(:site => mock_model(Site), :sponsor => mock_model(User), :body => users(:adam).email)
        @not_redundant = Posting::Invitation.create!(:site => mock_model(Site), :sponsor => mock_model(User), :body => 'zed@test.com')
      end
      
      it "shows redundant invitations" do
        Posting::Invitation.redundant.should == [ redundant_invitation ]
      end
      
      it "shows not redundant invitations" do
        Posting::Invitation.not_redundant.should == [ not_redundant_invitation ]
      end
    end
  end
end

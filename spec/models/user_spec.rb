require 'spec_helper'

describe User do  

  include Authlogic::TestCase
  
  before(:each) do
    activate_authlogic
    UserSession.stub!(:find).and_return(mock(UserSession, :record => mock_model(User)))
  end
  
  describe 'attributes' do    
    let(:attrs) do
      { :email => 'zed@test.com',
        :handle => 'zed',
        :password => 'test',
        :password_confirmation => 'test',
        :enrollment_site => mock_model(Site).as_null_object }
    end
    
    it 'is valid with valid attributes' do
      User.new(attrs).should be_valid
    end

    it 'requires an enrollment site' do
      user = User.new(attrs)
      user.enrollment_site = nil
      user.should_not be_valid
    end
    
    it 'requires a handle' do
      user = User.new(attrs)
      user.handle = nil
      user.should_not be_valid
    end

    it 'requires an email' do
      user = User.new(attrs)
      user.email = nil
      user.should_not be_valid
    end

    it 'requires something that looks like an email' do
      user = User.new(attrs)
      user.email = 'crap'
      user.should_not be_valid
    end
  
    it 'emailable by default' do
      User.new(attrs).should be_emailable
    end
  
    it 'is not emailable' do
      user = User.new(attrs)
      user.emailable = false
      user.should_not be_emailable
    end

    it 'is not an admin by default' do
      User.new(attrs).should_not be_an_admin
    end
  end

  describe 'enrollment' do
    let(:duncan) do
      User.new(:email => 'duncan@test.com', :password => 'test', :password_confirmation => 'test')      
    end
    
    fixtures :sites, :users, :postings

    describe "already enrolled" do
      it "is invalid at an open site" do
        user = users(:adam)
        user.enroll(sites(:friskyhands), 'adam')
        user.should_not be_valid
      end

      it "is invalid at an invite-only site" do
        user = users(:bert)
        user.enroll(sites(:positivelyfrisky), 'bert', 'b2')
        user.should_not be_valid
      end
    end
    
    describe "invite-only sites" do
      let(:ernie) do
        User.new(:email => 'ernie@test.com', :password => 'test', :password_confirmation => 'test')
      end
      
      describe "with a personal invitation" do
        it "is valid for an existing user" do
          user = users(:charlie)
          user.enroll(sites(:positivelyfrisky), 'charlie', 'c3')
          user.should be_valid
        end

        it "is valid for a new user" do
          duncan.enroll(sites(:positivelyfrisky), 'duncan', 'd4')
          duncan.should be_valid
        end
        
        it "is invalid if invitation exists but not in offered state" do
          site = sites(:positivelyfrisky)
          invitation = Posting::Invitation.create!(:sponsor => users(:adam), :site => site, :code => '666', :email => ernie.email, :state => 'accepted')
          ernie.enroll(site, 'ernie', '666')
          ernie.should_not be_valid
          ernie.errors.full_messages.join.should match(/has already been previously accepted/)
        end
        
        it "should be in accepted state after accepted" do
          site = sites(:positivelyfrisky)
          invitation = Posting::Invitation.create!(:sponsor => users(:adam), :site => site, :code => '666', :email => ernie.email)
          invitation.offer!
          ernie.enroll!(site, 'ernie', '666')
          invitation.reload
          invitation.state.should == 'accepted'
        end
      end
      
      describe "with an anonymous invitation" do
        it "is valid for an existing user" do          
          ernie.enroll!(sites(:friskyhands), 'ernie')
          ernie.enroll(sites(:positivelyfrisky), 'ernie', 'e5')
          ernie.should be_valid
        end

        it "is valid for a new user" do
          ernie.enroll(sites(:positivelyfrisky), 'ernie', 'e5')
          ernie.should be_valid
        end
        
        it "is invalid if invitation in accepted state" do
          site = sites(:positivelyfrisky)
          invitation = Posting::Invitation.create!(:sponsor => users(:adam), :site => site, :code => '666', :state => 'accepted')
          ernie.enroll(site, 'ernie', '666')          
          ernie.should_not be_valid
        end

        it "is invalid if invitation in expired state" do
          site = sites(:positivelyfrisky)
          invitation = Posting::Invitation.create!(:sponsor => users(:adam), :site => site, :code => '666', :state => 'offered')          
          invitation.expire!
          ernie.enroll(site, 'ernie', '666')          
          ernie.should_not be_valid
        end
        
        it "should remain in offered state after being accepted" do
          site = sites(:positivelyfrisky)
          invitation = Posting::Invitation.create!(:sponsor => users(:adam), :site => site, :code => '666')
          invitation.offer!
          ernie.enroll!(site, 'ernie', '666')
          invitation.reload
          invitation.state.should == 'offered'
        end
      end
      
      describe "without an invitation" do         
        it "is invalid for an existing user" do
          ernie.enroll!(sites(:friskyhands), 'ernie')
          ernie.enroll(sites(:positivelyfrisky), 'ernie', 666)
          ernie.should_not be_valid
        end
        
        it "is invalid for a new user" do
          ernie.enroll(sites(:positivelyfrisky), 'ernie', 666)
          ernie.should_not be_valid          
        end
        
        it "is valid with invitation override" do
          ernie.enroll(sites(:positivelyfrisky), 'ernie', 666, true)
          ernie.should be_valid
        end
      end
    end
        
    describe "open sites" do
      describe "without an invitation" do
        it "is valid for an existing user" do
          duncan.enroll!(sites(:positivelyfrisky), 'duncan', 'd4')
          duncan.enroll(sites(:friskyhands), 'duncan')
          duncan.should be_valid          
        end
        
        it "is valid for a new user" do
          duncan.enroll(sites(:friskyhands), 'duncan')
          duncan.should be_valid
        end
      end
    end    
  end
    
end

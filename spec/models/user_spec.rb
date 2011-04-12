require 'spec_helper'

describe User do
  
  describe 'attributes' do

    let(:user) do
      Factory.build(:adam)
    end
    
    it 'is valid with valid attributes' do      
      pending
      user.should be_valid
    end

    it 'requires a current_site' do
      pending
      Factory.build(:adam, :current_site => nil).should_not be_valid
    end
    
    it 'requires a handle' do
      pending
      user.handle = nil
      user.should_not be_valid
    end

    it 'requires an email' do
      pending
      user.email = nil
      user.should_not be_valid
    end

    it 'requires something that looks like an email' do
      pending
      user.email = 'crap'
      user.should_not be_valid
    end
  
    it 'emailable by default' do
      pending
      user.should be_emailable
    end
  
    it 'is not emailable' do
      pending
      user.emailable = false
      user.should_not be_emailable
    end

    it 'is not an admin by default' do
      pending
      user.should_not be_an_admin
    end

    describe 'invite sites' do
      it "valid with an invitation" do
        pending
        user = Factory.build(:adam, :current_site => Factory(:invite_site))
        # user.should be_valid
      end

      it "requires an invitation" do
        pending
        user = Factory.build(:adam, :current_site => Factory(:invite_site))        
        user.should_not be_valid
      end
    end
  end
    
end

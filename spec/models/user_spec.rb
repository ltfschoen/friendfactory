require 'spec_helper'

describe User do
  
  fixtures :users
  
  describe 'attributes' do
    let(:attrs) do
      { :first_name => 'duncan',
        :email => 'duncan@test.com',
        :password => 'test',
        :password_confirmation => 'test' }
    end

    let(:user) do
      User.new(attrs)
    end
  
    it "is valid with valid attributes" do
      user.should be_valid
    end
  
    it 'requires a first_name' do
      user.first_name = nil
      user.should_not be_valid
    end

    it 'requires an email' do
      user.email = nil
      user.should_not be_valid
    end

    it 'requires something that looks like an email' do
      user.email = 'crap'
      user.should_not be_valid
    end
  
    it 'emailable by default' do
      user.should be_emailable
    end
  
    it 'is not emailable' do
      user.emailable = false
      user.should_not be_emailable
    end

    it 'is not an admin by default' do
      user.should_not be_an_admin
    end
  end
  
  describe 'admin privileges' do
    it 'is not an admin' do
      users(:adam).should_not be_an_admin
    end

    it 'is an admin' do
      users(:charlie).should be_an_admin
    end
  end
  
end

require 'spec_helper'

describe User do
  
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
  
  it 'emailable' do
    user.should be_emailable
  end
  
  it 'is not emailable' do
    user.emailable = false
    user.should_not be_emailable
  end
  
end

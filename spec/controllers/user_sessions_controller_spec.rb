require 'spec_helper'

describe UserSessionsController do
  
  include Authlogic::TestCase
  setup :activate_authlogic
  
  fixtures :users  

  it 'remembers me for 4 weeks when remember_me is checked' do
    pending
    time_now = Time.now.utc + 4.weeks
    post :create, { :user_session => { :email => users(:adam).email, :password => 'test' }, :remember_me => '' }
    response['Set-Cookie'] =~ /expires=(.*)$/
    DateTime.parse($1).to_i.should be >= time_now.to_i
  end
  
  it "remembers me regardless if remember is checked" do
    pending
    post :create, { :user_session => { :email => users(:adam).email, :password => 'test' } }
    response['Set-Cookie'] =~ /expires=(.*)$/
    $1.should_not be_nil
  end  
  
end

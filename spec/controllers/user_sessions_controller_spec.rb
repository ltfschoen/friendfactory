require 'spec_helper'

describe UserSessionsController do
  include Authlogic::TestCase
  
  fixtures :users  
  setup :activate_authlogic

  it 'remembers me for 4 weeks' do
    time_now = Time.now.utc + 4.weeks
    post :create, { :user_session => { :email => users(:adam).email, :password => 'test' }, :remember_me => '' }
    response['Set-Cookie'] =~ /expires=(.*)$/
    DateTime.parse($1).to_i.should be >= time_now.to_i
  end
  
  it "doesn't remembers me" do
    post :create, { :user_session => { :email => users(:adam).email, :password => 'test' } }
    response['Set-Cookie'] =~ /expires=(.*)$/
    $1.should be_nil
  end  
  
end

require 'spec_helper'

describe Wave::ProfileController do
  include Authlogic::TestCase
  
  fixtures :users
  setup :activate_authlogic
  
  describe 'not logged in' do
    describe "GET 'show'" do
      it "should redirect to welcome controller" do
        get 'show'
        response.should redirect_to(welcome_path)
      end
    end
  end
  
  describe 'logged in' do
    before(:each) do
      #@user = Factory.build(:user)
      # activate_authlogic
      # UserSession.create(users(:adam))
    end

    it 'should render' do
      pending
      login({}, :profile => mock_model(Wave::Profile))
      get :show
      response.should render_template('waves/profile/show')
    end
  end

end

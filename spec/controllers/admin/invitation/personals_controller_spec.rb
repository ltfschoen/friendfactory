require 'spec_helper'

describe Admin::Invitation::PersonalsController do
  
  fixtures :sites, :users
  
  let(:wave) { mock_model(Wave::Invitation).as_null_object }

  describe 'administrator' do
    before(:each) do
      login(:friskyhands, :adam)
    end

    describe "GET index" do
      it "assigns invitation waves to @waves" do
        Wave::Invitation.should_receive(:find_all_by_site_and_fully_offered).and_return([ wave ])
        get :index
        assigns(:waves).should eq([ wave ])
      end
    end
  end
  
  describe 'not an administrator' do
    before(:each) do
      login(:friskyhands, :bert)
    end
    
    it "redirects to welcome" do
      get :index
      response.should redirect_to(welcome_url)
    end
  end

end

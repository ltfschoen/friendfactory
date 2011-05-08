require 'spec_helper'

describe Admin::Invitation::PersonalsController do
  
  fixtures :sites, :users
  
  describe "requires an administrator" do
    it "to access" do
      login(:positivelyfrisky, :adam)
      response.should be_successful
    end
    
    it "otherwise disallows" do
      get :index
      response.should redirect_to(welcome_url)
    end
  end

  describe 'GET index' do    
    let(:wave) { mock_model(Wave::Invitation).as_null_object }
        
    before(:each) { login(:friskyhands, :adam) }

    it "assigns invitation waves to @waves" do
      Wave::Invitation.should_receive(:find_all_by_site_and_fully_offered).and_return([ wave ])
      get :index
      assigns(:waves).should eq([ wave ])
    end
  end
  
end

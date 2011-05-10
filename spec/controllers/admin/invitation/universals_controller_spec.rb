require 'spec_helper'

describe Admin::Invitation::UniversalsController do
  
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
    let(:invitation) { mock_model(Posting::Invitation).as_null_object }
        
    before(:each) { login(:positivelyfrisky, :adam) }
    
    it "assigns universal invitations to @postings" do
      Posting::Invitation.stub_chain(:offered, :universal, :site).and_return([ invitation ])
      get :index
      assigns(:postings).should == [ invitation ]
    end
  end
  
end
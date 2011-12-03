require 'spec_helper'
require 'controllers/shared_examples_for_admin'

describe Admin::Invitation::PersonalsController, 'GET index' do

  it_should_behave_like 'administrator-only', :index

  context 'when logged in as an administrator' do
    let(:wave) do
      mock_model(Wave::Invitation).as_null_object
    end

    before(:each) do
      login_as_admin
      Wave::Invitation.should_receive(:find_all_by_site_and_fully_offered).and_return([ wave ])      
    end

    it 'assigns @waves' do
      get :index
      assigns(:waves).should eq([ wave ])
    end

    it 'renders index' do
      get :index
      response.should render_template('index')
    end
  end
end

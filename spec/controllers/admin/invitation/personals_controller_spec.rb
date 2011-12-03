require 'spec_helper'

describe Admin::Invitation::PersonalsController, 'GET index' do

  def not_logged_in
    controller.stub!(:current_user).and_return(nil)
  end

  def login_as_user
    controller.stub!(:current_user).and_return(mock_model(User, :admin? => false))
  end

  def login_as_admin
    controller.stub!(:current_user).and_return(mock_model(User, :admin? => true))
  end

  context 'when user not logged in' do
    before(:each) { not_logged_in }
    it 'redirects to welcome page' do
      get :index
      response.should redirect_to(welcome_url)
    end
  end

  context 'when user logged in' do
    before(:each) { login_as_user }
    it 'redirects to welcome page' do
      get :index
      response.should redirect_to(welcome_url)
    end
  end

  context 'when administrator logged in' do
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

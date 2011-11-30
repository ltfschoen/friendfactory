require 'spec_helper'

describe WelcomeController do

  let(:current_site) { mock_model(Site, :launch? => false).as_null_object }

  before(:each) do
    controller.stub(:current_site).and_return(current_site)
    controller.stub(:current_user_session).and_return(nil)
  end

  it "uses WelcomeController" do
    controller.should be_an_instance_of(WelcomeController)
  end

  describe "before filter" do
    it "doesn't allow a logged-in user" do
      controller.stub(:current_user).and_return(mock_model(User))
      get :show
      response.should redirect_to(logout_url)
    end
  end

  describe "GET show" do
    context "non-launch site" do
      it "creates new user with invitation code" do
        User.should_receive(:new).with(:invitation_code => '666')
        get :show, :invitation_code => '666'
      end

      it "assigns @user" do
        user = mock_model(User)
        User.stub(:new).and_return(user)
        get :show
        assigns[:user].should eq(user)
      end
    end
  end

  describe "POST signup" do
    let(:user) { mock_model(User).as_null_object }
    let(:user_session) { double.as_null_object }

    before(:each) do
      User.stub(:new).and_return(user)
      current_site.stub_chain(:user_sessions, :create).and_return(user_session)
    end

    context "when successful" do
      it "assigns to flash" do
        post :signup
        flash[:notice].should match(/Welcome to/)
      end

      it "redirects to root path" do
        post :signup
        response.should redirect_to(root_path)
      end
    end

    context "when unsuccessful" do
      it "renders the show template" do
        user.stub(:save).and_return(false)
        post :signup
        response.should render_template('show')
      end
    end
  end

  describe "POST login" do
    let(:user_session) { double.as_null_object }

    before(:each) do
      current_site.stub_chain(:user_sessions, :new).and_return(user_session)
      user_session.stub_chain(:record, :handle)
    end

    context "when successful" do
      it "assigns to flash" do
        post :login
        flash[:notice].should match(/Welcome back/)
      end

      it "redirects to root path" do
        post :login
        response.should redirect_to(root_path)
      end
    end

    context "when unsuccessful" do
      before(:each) do
        user_session.stub(:save).and_return(false)
        user_session.stub_chain(:errors, :full_messages).and_return('RTFM')
      end

      it "assigns @user" do
        user = mock_model(User)
        User.stub(:new).and_return(user)
        post :login
        assigns[:user].should eq(user)
      end

      it "assigns to flash" do
        post :login
        flash[:login].should eq('RTFM')
      end

      it "renders the show template" do
        post :login
        response.should render_template('show')
      end
    end
  end
end

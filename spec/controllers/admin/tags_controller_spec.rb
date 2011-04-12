require 'spec_helper'

describe Admin::TagsController do

  fixtures :users

  def mock_tag(stubs={})
    (@mock_tag ||= mock_model(Admin::Tag).as_null_object).tap do |tag|
      tag.stub(stubs) unless stubs.empty?
    end
  end
  
  describe 'administrator not logged in' do
    it 'redirects to welcome page' do
      pending
      get :index
      response.should redirect_to(welcome_path)
    end    
  end
    
  describe 'administrator logged in' do
    before(:each) do
      controller.stub(:current_user).and_return(users(:charlie))
    end
    
    describe "GET index" do
      it "assigns all admin_tags as @tags" do
        pending
        Admin::Tag.stub(:all) {[ mock_tag ]}
        get :index
        assigns(:tags).should eq([mock_tag])
      end
    end

    describe "GET new" do
      it "assigns a new tag as @tag" do
        pending
        Admin::Tag.stub(:new) { mock_tag }
        get :new
        assigns(:tag).should be(mock_tag)
      end
    end

    describe "GET edit" do
      it "assigns the requested tag as @tag" do
        pending
        Admin::Tag.stub(:find).with("37") { mock_tag }
        get :edit, :id => "37"
        assigns(:tag).should be(mock_tag)
      end
    end

    describe "POST create" do    
      describe "with valid params" do
        it "assigns a newly created tag as @tag" do
          pending
          Admin::Tag.stub(:new).with({ 'defective' => 'defect', 'corrected' => 'correct', 'taggable_type' => 'UserInfo' }) { mock_tag(:save => true) }
          post :create, :admin_tag => { :defective => 'defect', :corrected => 'correct' }
          assigns(:tag).should be(mock_tag)
        end

        it "redirects to index" do
          pending
          Admin::Tag.stub(:new) { mock_tag(:save => true) }
          post :create, :admin_tag => {}
          response.should redirect_to(admin_tags_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved tag as @tag" do
          pending
          Admin::Tag.stub(:new) { mock_tag(:save => false) }
          post :create, :admin_tag => {}
          assigns(:tag).should be(mock_tag)
        end

        it "re-renders the 'new' template" do
          pending
          Admin::Tag.stub(:new) { mock_tag(:save => false) }
          post :create, :admin_tag => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested tag" do
          pending
          Admin::Tag.should_receive(:find).with("37") { mock_tag }
          mock_tag.should_receive(:update_attributes).with({ 'defective' => 'defect' })
          put :update, :id => "37", :admin_tag => { :defective => 'defect' }
        end

        it "assigns the requested tag as @tag" do
          pending
          Admin::Tag.stub(:find) { mock_tag(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:tag).should be(mock_tag)
        end

        it "redirects to the tag" do
          pending
          Admin::Tag.stub(:find) { mock_tag(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(admin_tags_url)
        end
      end

      describe "with invalid params" do
        it "assigns the tag as @tag" do
          pending
          Admin::Tag.stub(:find) { mock_tag(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:tag).should be(mock_tag)
        end

        it "re-renders the 'edit' template" do
          pending
          Admin::Tag.stub(:find) { mock_tag(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested tag" do
        pending
        Admin::Tag.should_receive(:find).with("37") { mock_tag }
        mock_tag.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the admin_tags list" do
        pending
        Admin::Tag.stub(:find) { mock_tag }
        delete :destroy, :id => "1"
        response.should redirect_to(admin_tags_url)
      end
    end
  end
  
end

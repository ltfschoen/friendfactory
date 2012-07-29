require 'spec_helper'
require 'controllers/shared_examples_for_admin'

describe Admin::Invitation::SitesController do

  let(:current_site) { mock_model(Site) }

  before(:each) do
    login_as_admin
    controller.stub(:current_site).and_return(current_site)
  end

  it_should_behave_like 'administrator-only', :index, :new, :create, :edit, :update, :destroy, :id => '42'

  context 'when logged in as administrator' do
    describe "GET index" do
      let(:invitation) { mock_model(Posting::Invitation) }

      before(:each) do
        current_site.stub_chain(:invitations, :universal, :published, :order_by_updated_at_desc).and_return([ invitation ])
      end

      it "assigns @postings" do
        get :index
        assigns(:postings).should == [ invitation ]
      end

      it "renders index" do
        get :index
        response.should render_template('index')
      end
    end

    describe "GET edit" do
      let(:invitation) { mock_model(Posting::Invitation) }

      before(:each) do
        Posting::Invitation.stub_chain(:universal, :site, :find_by_id).with('42').and_return(invitation)
      end

      it "assigns @posting" do
        get :edit, :id => '42'
        assigns(:posting).should == invitation
      end

      it 'renders edit' do
        get :edit, :id => '42'
        response.should render_template('edit')
      end
    end
  end

end
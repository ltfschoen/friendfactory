require 'spec_helper'

describe Wave::PolaroidsController do

  def mock_wave(stubs={})
    (@mock_wave ||= mock_model(Wave::Polaroid).as_null_object).tap do |wave|
      wave.stub(stubs) unless stubs.empty?
    end
  end

  # describe "GET index" do
  #   it "assigns all wave_polaroids as @wave_polaroids" do
  #     Wave::Polaroid.stub(:all) { [mock_polaroid] }
  #     get :index
  #     assigns(:wave_polaroids).should eq([mock_polaroid])
  #   end
  # end

  describe "GET show" do
    it "assigns the requested polaroid as @wave" do
      Wave::Polaroid.should_receive(:find).once.with("37").and_return(mock_wave)
      get :show, { :id => "37" }, { :lurker => true }
      assigns(:wave).should be(mock_wave)
    end
  end

  # describe "GET new" do
  #   it "assigns a new polaroid as @polaroid" do
  #     Wave::Polaroid.stub(:new) { mock_polaroid }
  #     get :new
  #     assigns(:polaroid).should be(mock_polaroid)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested polaroid as @polaroid" do
  #     Wave::Polaroid.stub(:find).with("37") { mock_polaroid }
  #     get :edit, :id => "37"
  #     assigns(:polaroid).should be(mock_polaroid)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "assigns a newly created polaroid as @polaroid" do
  #       Wave::Polaroid.stub(:new).with({'these' => 'params'}) { mock_polaroid(:save => true) }
  #       post :create, :polaroid => {'these' => 'params'}
  #       assigns(:polaroid).should be(mock_polaroid)
  #     end
  # 
  #     it "redirects to the created polaroid" do
  #       Wave::Polaroid.stub(:new) { mock_polaroid(:save => true) }
  #       post :create, :polaroid => {}
  #       response.should redirect_to(wave_polaroid_url(mock_polaroid))
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved polaroid as @polaroid" do
  #       Wave::Polaroid.stub(:new).with({'these' => 'params'}) { mock_polaroid(:save => false) }
  #       post :create, :polaroid => {'these' => 'params'}
  #       assigns(:polaroid).should be(mock_polaroid)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       Wave::Polaroid.stub(:new) { mock_polaroid(:save => false) }
  #       post :create, :polaroid => {}
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested polaroid" do
  #       Wave::Polaroid.should_receive(:find).with("37") { mock_polaroid }
  #       mock_wave_polaroid.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :polaroid => {'these' => 'params'}
  #     end
  # 
  #     it "assigns the requested polaroid as @polaroid" do
  #       Wave::Polaroid.stub(:find) { mock_polaroid(:update_attributes => true) }
  #       put :update, :id => "1"
  #       assigns(:polaroid).should be(mock_polaroid)
  #     end
  # 
  #     it "redirects to the polaroid" do
  #       Wave::Polaroid.stub(:find) { mock_polaroid(:update_attributes => true) }
  #       put :update, :id => "1"
  #       response.should redirect_to(wave_polaroid_url(mock_polaroid))
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the polaroid as @polaroid" do
  #       Wave::Polaroid.stub(:find) { mock_polaroid(:update_attributes => false) }
  #       put :update, :id => "1"
  #       assigns(:polaroid).should be(mock_polaroid)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Wave::Polaroid.stub(:find) { mock_polaroid(:update_attributes => false) }
  #       put :update, :id => "1"
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested polaroid" do
  #     Wave::Polaroid.should_receive(:find).with("37") { mock_polaroid }
  #     mock_wave_polaroid.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the wave_polaroids list" do
  #     Wave::Polaroid.stub(:find) { mock_polaroid }
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(wave_polaroids_url)
  #   end
  # end

end

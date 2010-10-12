require 'spec_helper'

describe WavesController do
  
  def mock_wave(stubs={})
    @mock_wave ||= mock_model(Wave::Base, stubs)
  end

  # describe "GET index" do
  #   it "assigns all waves as @waves" do
  #     pending do
  #       Wave.stub(:find).with(:all).and_return([mock_wave])
  #       get :index
  #       assigns[:waves].should == [mock_wave]
  #     end
  #   end
  # end
  
  describe "GET show" do
    it "assigns the requested wave with id as @wave" do
      Wave::Base.should_receive(:find_by_id).once.with("37").and_return(mock_wave)
      get :show, { :id => "37" }, { :lurker => true }
      assigns[:wave].should equal(mock_wave)
    end

    it "assigns the requested wave with slug as @wave" do
      Wave::Base.should_receive(:find_by_slug).once.with("hotties").and_return(mock_wave)
      get :show, { :slug => "hotties" }, { :lurker => true }
      assigns[:wave].should equal(mock_wave)
    end
    
    it "assigns the default wave when given no parameters" do
      wave = Factory.build(:wave)
      Wave::Base.should_receive(:find_by_slug).with(WavesController::DefaultWaveSlug).and_return(wave)
      get :show, nil, { :lurker => true }
      assigns[:wave].should equal(wave)
    end
    
    it "raises an exception when there's no default wave" do
      Wave::Base.should_receive(:find_by_slug).with(WavesController::DefaultWaveSlug).and_return(nil)
      expect { get :show, nil, { :lurker => true } }.to raise_error(ConfigurationException)
    end
  end
  
  # describe "GET new" do
  #   it "assigns a new wave as @wave" do
  #     pending do
  #       Wave.stub(:new).and_return(mock_wave)
  #       get :new
  #       assigns[:wave].should equal(mock_wave)
  #     end
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested wave as @wave" do
  #     pending do
  #       Wave.stub(:find).with("37").and_return(mock_wave)
  #       get :edit, :id => "37"
  #       assigns[:wave].should equal(mock_wave)
  #     end
  #   end
  # end
  # 
  # describe "POST create" do
  #   describe "with valid params" do
  #     it "assigns a newly created wave as @wave" do
  #       pending do
  #         Wave.stub(:new).with({'these' => 'params'}).and_return(mock_wave(:save => true))
  #         post :create, :wave => {:these => 'params'}
  #         assigns[:wave].should equal(mock_wave)
  #       end
  #     end
  # 
  #     it "redirects to the created wave" do
  #       pending do
  #         Wave.stub(:new).and_return(mock_wave(:save => true))
  #         post :create, :wave => {}
  #         response.should redirect_to(wafe_url(mock_wave))
  #       end
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved wave as @wave" do
  #       pending do
  #         Wave.stub(:new).with({'these' => 'params'}).and_return(mock_wave(:save => false))
  #         post :create, :wave => {:these => 'params'}
  #         assigns[:wave].should equal(mock_wave)
  #       end
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       pending do
  #         Wave.stub(:new).and_return(mock_wave(:save => false))
  #         post :create, :wave => {}
  #         response.should render_template('new')
  #       end
  #     end
  #   end
  # 
  # end
  # 
  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested wave" do
  #       pending do
  #         Wave.should_receive(:find).with("37").and_return(mock_wave)
  #         mock_wave.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :wave => {:these => 'params'}
  #       end
  #     end
  # 
  #     it "assigns the requested wave as @wave" do
  #       pending do
  #         Wave.stub(:find).and_return(mock_wave(:update_attributes => true))
  #         put :update, :id => "1"
  #         assigns[:wave].should equal(mock_wave)
  #       end
  #     end
  # 
  #     it "redirects to the wave" do
  #       pending do 
  #         Wave.stub(:find).and_return(mock_wave(:update_attributes => true))
  #         put :update, :id => "1"
  #         response.should redirect_to(wafe_url(mock_wave))
  #       end
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "updates the requested wave" do
  #       pending do
  #         Wave.should_receive(:find).with("37").and_return(mock_wave)
  #         mock_wave.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :wave => {:these => 'params'}
  #       end
  #     end
  # 
  #     it "assigns the wave as @wave" do
  #       pending do
  #         Wave.stub(:find).and_return(mock_wave(:update_attributes => false))
  #         put :update, :id => "1"
  #         assigns[:wave].should equal(mock_wave)
  #       end
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       pending do
  #         Wave.stub(:find).and_return(mock_wave(:update_attributes => false))
  #         put :update, :id => "1"
  #         response.should render_template('edit')
  #       end
  #     end
  #   end
  # 
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested wave" do
  #     pending do
  #       Wave.should_receive(:find).with("37").and_return(mock_wave)
  #       mock_wave.should_receive(:destroy)
  #       delete :destroy, :id => "37"
  #     end
  #   end
  # 
  #   it "redirects to the waves list" do
  #     pending do
  #       Wave.stub(:find).and_return(mock_wave(:destroy => true))
  #       delete :destroy, :id => "1"
  #       response.should redirect_to(waves_url)
  #     end
  #   end
  # end

end

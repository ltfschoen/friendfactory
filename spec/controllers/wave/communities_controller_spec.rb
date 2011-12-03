require 'spec_helper'

describe Wave::CommunitiesController do

  def mock_wave(stubs={})
    @mock_wave ||= mock_model(Wave::Base, stubs)
  end

  describe 'requires lurker' do
    before(:each) { not_logged_in }
    it 'redirects to welcome page' do
      get :show
      response.should redirect_to(welcome_url)
    end
  end

  describe "GET show" do
    it "assigns the requested wave with :slug as @wave" do
      pending
      Wave::Base.should_receive(:find_by_slug).once.with("hotties").and_return(mock_wave)
      get :show, { :slug => "hotties" }, { :lurker => true }
      assigns[:wave].should equal(mock_wave)
    end

    it "assigns the default wave as @wave when given no parameters" do
      pending
      wave = Factory.build(:wave_community)
      Wave::Base.should_receive(:find_by_slug).with(Wave::CommunitiesController::DefaultWaveSlug).and_return(wave)
      get :show, nil, { :lurker => true }
      assigns[:wave].should equal(wave)
    end    
  end
end

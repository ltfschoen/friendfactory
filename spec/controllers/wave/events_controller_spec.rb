require 'spec_helper'

describe Wave::EventsController do

  fixtures :sites, :waves, :sites_waves, :resource_events, :locations

  set_fixture_class :waves => 'Wave::Event'
       
  describe "GET index" do
    describe 'friskyhands' do
      before(:each) do
        current_site(sites(:friskyhands))
      end
    
      it "assigns FH's published events to @waves" do
        get :index
        assigns[:waves].should == [ waves(:event_wave_published) ]
      end
    
      it "assigns events' tags counts to @tags" do
        Wave::Event.all.each { |event| event.save! }
        get :index
        assigns[:tags].first.name.should == locations(:burraneer).city
      end
    end
    
    describe 'positivelyfrisky' do
      it 'assigns PF published events to @waves' do
        current_site(sites(:positivelyfrisky))
        get :index
        assigns[:waves].should == [ waves(:event_wave_positivelyfrisky) ]       
      end      
    end
  end
  
end

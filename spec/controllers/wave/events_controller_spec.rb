require 'spec_helper'

describe Wave::EventsController do

  # fixtures :all
  # set_fixture_class :waves => 'Wave::Base', :postings => 'Posting::Base'

  describe "GET index" do
    describe 'friskyhands' do
      before(:each) do
        # login(:friskyhands, :adam)
      end

      it "assigns FH's published events to @waves" do
        pending
        get :index
        assigns[:waves].should == [ waves(:event_wave_published) ]
      end

      it "assigns events' tags counts to @tags" do
        pending
        Wave::Event.all.each { |event| event.save! }
        get :index
        assigns[:tags].first.name.should == locations(:burraneer).city
      end
    end

    describe 'positivelyfrisky' do
      it 'assigns PF published events to @waves' do
        pending
        login(:positivelyfrisky, :adam)
        get :index
        assigns[:waves].should == [ waves(:event_wave_positivelyfrisky) ]
      end
    end
  end

end

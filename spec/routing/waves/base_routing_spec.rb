require 'spec_helper'

describe Waves::BaseController do
  describe 'routing' do
    describe 'show by slug' do
      it 'recognizes #show by :slug' do
        { :get => '/waves/hotties' }.should route_to(:controller => 'waves/base', :action => 'show', :slug => 'hotties')
      end

      it 'recognizes waves_slug_path' do
        waves_slug_path('hotties').should == '/waves/hotties'
      end
      
      it "doesn't recognizes post #show" do
        { :post => "/waves/hotties" }.should_not be_routable
      end
      
      it "doesn't recognizes put #show" do
        { :put => "/waves/hotties" }.should_not be_routable
      end

      it "doesn't recognizes delete #show" do
        { :delete => "/waves/hotties" }.should_not be_routable
      end
    end
  end
end

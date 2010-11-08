require 'spec_helper'

describe Wave::BaseController do
  describe 'routing' do
    describe 'show by slug' do
      it 'recognizes get /wave/:slug' do
        { :get => '/wave/hotties' }.should route_to(:controller => 'wave/base', :action => 'show', :slug => 'hotties')
      end

      it 'recognizes slug waves path' do
        wave_slug_path('hotties').should == '/wave/hotties'
      end
      
      it "doesn't recognizes post /wave/:slug" do
        { :post => "/wave/hotties" }.should_not be_routable
      end
      
      it "doesn't recognizes put /wave/:slug" do
        { :put => "/wave/hotties" }.should_not be_routable
      end

      it "doesn't recognizes delete /wave/:slug" do
        { :delete => "/wave/hotties" }.should_not be_routable
      end      
    end
  end
end

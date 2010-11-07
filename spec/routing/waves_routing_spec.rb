require 'spec_helper'

describe WavesController do
  describe 'routing' do
    describe 'show by slugs' do
      it 'recognizes get /waves/:slug' do
        { :get => "/waves/hotties" }.should route_to(:controller => "waves", :action => "show", :slug => "hotties")
      end

      it 'recognizes slug waves path' do
        slug_wave_path('hotties').should == '/waves/hotties'
      end

      it "doesn't recognizes post /waves/:slug" do
        { :post   => "/waves/hotties" }.should_not be_routable
      end

      it "doesn't recognizes put /waves/:slug" do
        { :put   => "/waves/hotties" }.should_not be_routable
      end

      it "doesn't recognizes delete /waves/:slug" do
        { :delete   => "/waves/hotties" }.should_not be_routable
      end      
    end

    # describe 'show by id' do
    #   it 'recognizes get /waves/:id' do
    #     { :get => "/waves/1" }.should route_to(:controller => "waves", :action => "show", :id => "1")
    #   end
    # 
    #   it "doesn't recognizes post /waves/:id" do
    #     { :post   => "/waves/1" }.should_not be_routable
    #   end
    # 
    #   it "doesn't recognizes put /waves/:id" do
    #     { :put   => "/waves/1" }.should_not be_routable
    #   end
    # 
    #   it "doesn't recognizes delete /waves/:id" do
    #     { :delete   => "/waves/1" }.should_not be_routable
    #   end
    # end

    # it "recognizes and generates #edit" do
    #   pending do
    #     { :get => "/waves/1/edit" }.should route_to(:controller => "waves", :action => "edit", :id => "1")
    #   end
    # end

    # it "recognizes and generates #create" do
    #   pending do
    #     { :post => "/waves" }.should route_to(:controller => "waves", :action => "create") 
    #   end
    # end
    
    # it "recognizes and generates #update" do
    #   pending do
    #     { :put => "/waves/1" }.should route_to(:controller => "waves", :action => "update", :id => "1") 
    #   end
    # end
    
    # it "recognizes and generates #destroy" do
    #   pending do
    #     { :delete => "/waves/1" }.should route_to(:controller => "waves", :action => "destroy", :id => "1") 
    #   end
    # end
  end
end

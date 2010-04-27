require 'spec_helper'

describe FriendshipsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/friendships" }.should route_to(:controller => "friendships", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/friendships/new" }.should route_to(:controller => "friendships", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/friendships/1" }.should route_to(:controller => "friendships", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/friendships/1/edit" }.should route_to(:controller => "friendships", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/friendships" }.should route_to(:controller => "friendships", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/friendships/1" }.should route_to(:controller => "friendships", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/friendships/1" }.should route_to(:controller => "friendships", :action => "destroy", :id => "1") 
    end
  end
end

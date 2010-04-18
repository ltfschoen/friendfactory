require 'spec_helper'

describe PostingsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/postings" }.should route_to(:controller => "postings", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/postings/new" }.should route_to(:controller => "postings", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/postings/1" }.should route_to(:controller => "postings", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/postings/1/edit" }.should route_to(:controller => "postings", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/postings" }.should route_to(:controller => "postings", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/postings/1" }.should route_to(:controller => "postings", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/postings/1" }.should route_to(:controller => "postings", :action => "destroy", :id => "1") 
    end
  end
end

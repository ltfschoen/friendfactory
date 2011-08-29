require 'spec_helper'

describe FriendshipsController do
  describe "routing" do
    it 'recognizes #buddy' do
      { :put => '/friendships/new/42/buddy' }.should route_to(:controller => 'friendships', :action => 'buddy', :id => '42')
    end

    it 'recognizes buddy_new_friendship_path' do
      buddy_new_friendship_path(:id => '42').should == '/friendships/new/42/buddy'
    end

    # it "recognizes and generates #index" do
    #   { :get => "/buddies" }.should route_to(:controller => "buddies", :action => "index")
    # end
    # 
    # it "recognizes and generates #new" do
    #   { :get => "/buddies/new" }.should route_to(:controller => "buddies", :action => "new")
    # end
    # 
    # it "recognizes and generates #show" do
    #   { :get => "/buddies/1" }.should route_to(:controller => "buddies", :action => "show", :id => "1")
    # end
    # 
    # it "recognizes and generates #edit" do
    #   { :get => "/buddies/1/edit" }.should route_to(:controller => "buddies", :action => "edit", :id => "1")
    # end
    # 
    # it "recognizes and generates #create" do
    #   { :post => "/buddies" }.should route_to(:controller => "buddies", :action => "create") 
    # end
    # 
    # it "recognizes and generates #update" do
    #   { :put => "/buddies/1" }.should route_to(:controller => "buddies", :action => "update", :id => "1") 
    # end
    # 
    # it "recognizes and generates #destroy" do
    #   { :delete => "/buddies/1" }.should route_to(:controller => "buddies", :action => "destroy", :id => "1") 
    # end
  end
end

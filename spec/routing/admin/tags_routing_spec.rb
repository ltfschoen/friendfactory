require "spec_helper"

module Admin
  describe TagsController do
    describe "routing" do
      it "recognizes and generates #index" do
        pending
        { :get => "/admin/tags" }.should route_to(:controller => "admin/tags", :action => "index")
      end

      it "recognizes and generates #new" do
        pending
        { :get => "/admin/tags/new" }.should route_to(:controller => "admin/tags", :action => "new")
      end

      it "recognizes and generates #edit" do
        pending
        { :get => "/admin/tags/1/edit" }.should route_to(:controller => "admin/tags", :action => "edit", :id => "1")
      end

      it "recognizes and generates #create" do
        pending
        { :post => "/admin/tags" }.should route_to(:controller => "admin/tags", :action => "create")
      end

      it "recognizes and generates #update" do
        pending
        { :put => "/admin/tags/1" }.should route_to(:controller => "admin/tags", :action => "update", :id => "1")
      end

      it "recognizes and generates #destroy" do
        pending
        { :delete => "/admin/tags/1" }.should route_to(:controller => "admin/tags", :action => "destroy", :id => "1")
      end

      it "recognizes and generates #commit" do
        pending
        { :get => "/admin/tags/commit" }.should route_to(:controller => "admin/tags", :action => "commit")
      end

      it 'recognizes commit path' do
        pending
        commit_admin_tags_path.should == '/admin/tags/commit'
      end
    end
  end
end

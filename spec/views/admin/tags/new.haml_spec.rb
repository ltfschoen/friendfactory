require 'spec_helper'

describe "admin_tags/new.html.erb" do
  before(:each) do
    assign(:tag, stub_model(Admin::Tag,
      :old_tag => "MyString",
      :new_tag => "MyString"
    ).as_new_record)
  end

  it "renders new tag form" do
    pending
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_tags_path, :method => "post" do
      assert_select "input#tag_old_tag", :name => "tag[old_tag]"
      assert_select "input#tag_new_tag", :name => "tag[new_tag]"
    end
  end
end

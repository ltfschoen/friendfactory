require 'spec_helper'

describe "admin_tags/edit.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Admin::Tag,
      :new_record? => false,
      :old_tag => "MyString",
      :new_tag => "MyString"
    ))
  end

  it "renders the edit tag form" do
    pending
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => tag_path(@tag), :method => "post" do
      assert_select "input#tag_old_tag", :name => "tag[old_tag]"
      assert_select "input#tag_new_tag", :name => "tag[new_tag]"
    end
  end
end

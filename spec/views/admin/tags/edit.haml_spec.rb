require 'spec_helper'

describe "admin_tags/edit.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Admin::Tag,
      :new_record? => false,
      :defective => "MyString",
      :corrected => "MyString"
    ))
  end

  it "renders the edit tag form" do
    pending
    render
    rendered.should have_selector("form", :action => tag_path(@tag), :method => "post") do |form|
      form.should have_selector("input#tag_defective", :name => "tag[defective]")
      form.should have_selector("input#tag_corrected", :name => "tag[corrected]")
    end
  end
end

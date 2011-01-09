require 'spec_helper'

describe "admin_tags/new.html.erb" do
  before(:each) do
    assign(:tag, stub_model(Admin::Tag,
      :defective => "MyString",
      :corrected => "MyString"
    ).as_new_record)
  end

  it "renders new tag form" do
    pending
    render
    rendered.should have_selector("form", :action => admin_tags_path, :method => "post") do |form|
      form.should have_selector("input#tag_defective", :name => "tag[defective]")
      form.should have_selector("input#tag_corrected", :name => "tag[corrected]")
    end
  end
end

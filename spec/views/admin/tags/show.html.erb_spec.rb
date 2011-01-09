require 'spec_helper'

describe "admin_tags/show.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Admin::Tag,
      :old_tag => "Old Tag",
      :new_tag => "New Tag"
    ))
  end

  it "renders attributes in <p>" do
    pending
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Old Tag/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/New Tag/)
  end
end

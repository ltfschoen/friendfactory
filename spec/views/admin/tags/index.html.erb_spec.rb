require 'spec_helper'

describe "admin_tags/index.html.erb" do
  before(:each) do
    assign(:admin_tags, [
      stub_model(Admin::Tag,
        :old_tag => "Old Tag",
        :new_tag => "New Tag"
      ),
      stub_model(Admin::Tag,
        :old_tag => "Old Tag",
        :new_tag => "New Tag"
      )
    ])
  end

  it "renders a list of admin_tags" do
    pending
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Old Tag".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "New Tag".to_s, :count => 2
  end
end

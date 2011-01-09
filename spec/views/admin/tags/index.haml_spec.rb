require 'spec_helper'

describe "admin_tags/index.html.erb" do
  before(:each) do
    assign(:admin_tags, [
      stub_model(Admin::Tag,
        :defective => "Defective",
        :corrected => "Corrected"
      ),
      stub_model(Admin::Tag,
        :defective => "Defective",
        :corrected => "Corrected"
      )
    ])
  end

  it "renders a list of admin_tags" do
    pending
    render
    rendered.should have_selector("tr>td", :content => "Defective".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Corrected".to_s, :count => 2)
  end
end

require 'spec_helper'

describe "admin_tags/show.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Admin::Tag,
      :defective => "Defective",
      :corrected => "Corrected"
    ))
  end

  it "renders attributes in <p>" do
    pending
    render
    rendered.should contain("Defective".to_s)
    rendered.should contain("Corrected".to_s)
  end
end

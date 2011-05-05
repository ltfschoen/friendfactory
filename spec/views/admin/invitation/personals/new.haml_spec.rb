require 'spec_helper'

describe "admin_invitation_personals/new.html.erb" do
  before(:each) do
    # assign(:personal, stub_model(Admin::Invitation::Personal).as_new_record)
  end

  it "renders new personal form" do
    pending
    render
    rendered.should have_selector("form", :action => admin_invitation_personals_path, :method => "post") do |form|
    end
  end
end

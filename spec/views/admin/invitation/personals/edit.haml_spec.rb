require 'spec_helper'

describe "admin_invitation_personals/edit.html.erb" do
  before(:each) do
    # @personal = assign(:personal, stub_model(Admin::Invitation::Personal))
  end

  it "renders the edit personal form" do
    pending
    render
    rendered.should have_selector("form", :action => personal_path(@personal), :method => "post") do |form|
    end
  end
end

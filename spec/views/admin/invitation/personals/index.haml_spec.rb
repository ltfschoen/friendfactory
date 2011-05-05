require 'spec_helper'

describe "admin_invitation_personals/index.haml" do
  before(:each) do
    assign(:admin_invitation_personals, [
      # stub_model(Admin::Invitation::Personal),
      # stub_model(Admin::Invitation::Personal)
    ])
  end

  it "renders a list of admin_invitation_personals" do
    pending
    render
  end
end

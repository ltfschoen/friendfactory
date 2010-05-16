require 'spec_helper'

describe "/friendships/show.html.erb" do
  include FriendshipsHelper
  before(:each) do
    assigns[:friendship] = @friendship = stub_model(Friendship,
      :user_id => 1,
      :buddy_id => 1
    )
  end

  it "renders attributes in <p>" do
    pending
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

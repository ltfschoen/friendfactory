require 'spec_helper'

describe "/friendships/edit.html.erb" do
  # include FriendshipsHelper

  before(:each) do
    assigns[:friendship] = @friendship = stub_model(Friendship,
      :new_record? => false,
      :user_id => 1,
      :buddy_id => 1
    )
  end

  it "renders the edit friendship form" do
    pending
    render

    response.should have_tag("form[action=#{friendship_path(@friendship)}][method=post]") do
      pending
      with_tag('input#friendship_user_id[name=?]', "friendship[user_id]")
      with_tag('input#friendship_buddy_id[name=?]', "friendship[buddy_id]")
    end
  end
end

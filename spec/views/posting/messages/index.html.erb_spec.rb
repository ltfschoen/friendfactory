require 'spec_helper'

describe "/messages/index.html.erb" do
  # include MessagesHelper

  before(:each) do
    assigns[:messages] = [
      stub_model(Posting::Message),
      stub_model(Posting::Message)
    ]
  end

  # it "renders a list of messages" do
  #   render
  # end
end

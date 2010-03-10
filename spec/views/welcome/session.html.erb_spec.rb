require 'spec_helper'

describe "/welcome/session" do
  before(:each) do
    render 'welcome/session'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/welcome/session])
  end
end

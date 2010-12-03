require 'spec_helper'

describe "/search/index" do
  before(:each) do
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    pending
    render 'search/show'
    response.should have_tag('p', %r[Find me in app/views/search/index])
  end
end

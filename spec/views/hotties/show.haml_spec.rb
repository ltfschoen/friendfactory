require 'spec_helper'

describe "/hotties/show" do
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    assigns[:wave] = stub('Wave', :topic => 'hotties')
    pending
    render
    response.should have_tag('p', %r[Find me in app/views/hotties/show])
  end
end

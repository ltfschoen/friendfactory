require 'spec_helper'

describe FriendshipsHelper do

  #Delete this example and add some real ones or delete this file
  it "is included in the helper object" do
    pending
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(FriendshipsHelper)
  end

end

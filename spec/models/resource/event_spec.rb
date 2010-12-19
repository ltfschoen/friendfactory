require 'spec_helper'

describe Resource::Event do
  
  it 'saves a newly created location when persisted' do
    event_info = Resource::Event.create(:location => { :name => 'Location' })
    event_info.location.name.should == 'Location'
    event_info.location.id.should_not be_nil    
  end
  
end

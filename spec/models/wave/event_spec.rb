require 'spec_helper'

describe Wave::Event do
  
  fixtures :users
  
  let(:attrs) {{ :promoter_name => 'Promoter', :description => 'Description' }}
    
  let(:event) do
    wave = Wave::Event.new(attrs)
    wave.user = users(:adam)
    wave
  end
  
  it 'is valid with valid attributes' do
    event.should be_valid
  end

  it 'is not valid without a user' do
    event.user = nil
    event.should_not be_valid
  end
  
  it 'has a read-only user_id attribute' do
    event.save    
    event.user = users(:bert)
    event.save && event.reload
    event.user.should == users(:adam)
  end

  it 'does not allow bulk assignment of user_id' do
    Wave::Event.new(attrs.merge(:user_id => users(:adam).id)).should_not be_valid
  end
  
  it 'is not valid without a promoter' do
    event.promoter_name = nil
    event.should_not be_valid
  end

  it 'is not valid without a description' do
    event.description = nil
    event.should_not be_valid
  end
    
  it 'can have a start_date' do
    start_date = Date.today
    event.start_date = start_date.strftime('%m/%d/%Y')
    event.resource.start_date.should == start_date
  end

  it 'can have a end_date' do
    end_date = Date.today
    event.end_date = end_date.strftime('%m/%d/%Y')
    event.resource.end_date.should == end_date
  end
  
  it 'can have a body' do
    event = Wave::Event.new(attrs.merge({ :body => 'Body'}))
    event.resource.body.should == 'Body'
    event.body.should == 'Body'
  end
  
  it 'can have a location' do
    event = Wave::Event.new(attrs.merge({ :location => { :name => 'Location' }}))
    event.resource.location.name.should == 'Location'
    event.location.name.should == 'Location'
  end
  
end

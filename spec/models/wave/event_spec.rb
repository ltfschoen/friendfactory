require 'spec_helper'

describe Wave::Event do
  
  fixtures :users
  
  let(:attrs) do
    { :promoter_name => 'Promoter', :description => 'Description' }
  end
    
  let(:event) do
    wave = Wave::Event.new(attrs)
    wave.user = users(:adam)
    wave
  end
  
  it 'is valid with valid attributes' do
    pending
    event.should be_valid
  end

  it 'is not valid without a user' do
    pending
    event.user = nil
    event.should_not be_valid
  end
  
  it 'has a read-only user attribute' do
    pending
    event.save    
    event.user = users(:bert)
    event.save && event.reload
    event.user.should == users(:adam)
  end

  it 'does not allow bulk assignment of user_id' do
    pending
    Wave::Event.new(attrs.merge(:user_id => users(:adam).id)).should_not be_valid
  end
  
  it 'is not valid without a promoter' do
    pending
    event.promoter_name = nil
    event.should_not be_valid
  end

  it 'is not valid without a description' do
    pending
    event.description = nil
    event.should_not be_valid
  end
    
  it 'can have a start_date' do
    pending
    start_date = 'Friday, December 25th, 2010'
    event.start_date = start_date
    event.resource.start_date.should == DateTime.civil(2010, 12, 25)
  end

  it 'can have a end_date' do
    pending
    end_date = 'Friday, December 25th, 2010'
    event.end_date = end_date
    event.resource.end_date.should == DateTime.civil(2010, 12, 25)
  end
  
  it 'can have a body' do
    pending
    event = Wave::Event.new(attrs.merge({ :body => 'Body'}))
    event.resource.body.should == 'Body'
    event.body.should == 'Body'
  end
  
  it 'can have a location' do
    pending
    event = Wave::Event.new(attrs.merge({ :location => { :name => 'Location' }}))
    event.resource.location.name.should == 'Location'
    event.location.name.should == 'Location'
  end
  
end

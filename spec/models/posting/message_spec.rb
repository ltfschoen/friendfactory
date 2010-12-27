require 'spec_helper'

describe Posting::Message do
  
  fixtures :users
  
  let(:attrs) do
    { :subject     => 'the subject',
      :body        => 'the body',
      :receiver_id => users(:bert).id }
  end
  
  let(:message) do
    message = Posting::Message.new(attrs)
    message.user_id = users(:adam)
    message
  end
  
  it "is valid with valid attributes" do
    message.should be_valid
  end

  it "is not valid without a user" do
    message.user_id = nil
    message.should_not be_valid
  end

  it "is not valid without a receiver" do
    message.receiver_id = nil
    message.should_not be_valid
  end
  
  it 'aliases sender to user' do
    message.sender.should == message.user
  end
  
  it 'has a read-only user attribute' do
    message.save!
    message.user = users(:bert)
    message.save! && message.reload
    message.user.should == users(:adam)
  end
  
  describe 'receiver' do
    it 'is a read-only attribute' do
      message.save!
      message.update_attribute(:receiver_id, users(:charlie))
      message.save!    
      Posting::Message.find_by_id(message.id).receiver.should == users(:bert)
    end
  
    it 'derived from the recipient wave' do
      duncan = Factory(:duncan)
      message.receiver_id = nil
      message.stub_chain(:waves, :where, :first).and_return(Factory(:wave_conversation, :user => duncan))
      message.receiver.should == duncan
    end
  end
  
  describe 'email' do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    
    it 'is sent when the receiver is offline' do
      User.stub(:online).and_return([])
      message.save!
      ActionMailer::Base.deliveries.should have(1).item
    end

    it 'is not when the receiver is online' do
      User.stub(:online).and_return([ users(:bert)])
      message.save!
      ActionMailer::Base.deliveries.should be_empty
    end    
  end
  
  describe 'inbox' do
    it "creates a new receiver's wave" do
      message.save!
      wave = message.waves.where('user_id = ?', users(:bert).id).first
      users(:bert).conversations.should include(wave)
    end
    
    it "adds the receiver's wave to their inbox" do
      users(:bert).create_inbox
      message.save!
      wave = message.waves.where('user_id = ?', users(:bert).id).first
      users(:bert).inbox.waves.should include(wave)
    end
  end

end

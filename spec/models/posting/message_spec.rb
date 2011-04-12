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
  
  describe 'is valid' do
    it 'with valid attributes' do
      pending
      message.should be_valid
    end
  end

  describe 'is not valid' do
    it "without a user" do
      pending
      message.user_id = nil
      message.should_not be_valid
    end

    it "without a receiver" do
      pending
      message.receiver_id = nil
      message.should_not be_valid
    end
  end
  
  it 'aliases sender to user' do
    pending
    message.sender.should == message.user
  end
  
  it 'has a read-only user attribute' do
    pending
    message.save!
    message.user = users(:bert)
    message.save! && message.reload
    message.user.should == users(:adam)
  end
  
  describe 'receiver' do
    it 'is a read-only attribute' do
      pending
      message.save!
      message.update_attribute(:receiver_id, users(:charlie))
      message.save!    
      Posting::Message.find_by_id(message.id).receiver.should == users(:bert)
    end
  
    it 'derived from the recipient wave' do
      pending
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
      pending
      User.stub(:online).and_return([])
      message.save!
      ActionMailer::Base.deliveries.should have(1).item
    end

    it 'is not sent when the receiver is online' do
      pending
      User.stub(:online).and_return([ users(:bert) ])
      message.save!
      ActionMailer::Base.deliveries.should be_empty
    end

    it 'is sent if the receiver is emailable' do
      pending
      User.stub(:online).and_return([])
      message.receiver.emailable = true
      message.save!
      ActionMailer::Base.deliveries.should have(1).item      
    end
    
    it 'is not sent if the receiver is not emailable' do
      pending
      User.stub(:online).and_return([])
      receiver = message.receiver
      receiver.emailable = false
      receiver.save!
      message.save!
      ActionMailer::Base.deliveries.should be_empty
    end            
  end
  
  describe 'inbox' do
    it "creates a new receiver's wave" do
      pending
      message.save!
      wave = message.waves.where('user_id = ?', users(:bert).id).first
      users(:bert).conversations.should include(wave)
    end
    
    it "adds the receiver's wave to their inbox" do
      pending
      users(:bert).create_inbox
      message.save!
      wave = message.waves.where('user_id = ?', users(:bert).id).first
      users(:bert).inbox.waves.should include(wave)
    end
  end

end

require 'spec_helper'

describe Posting::MessagesController do

  fixtures :sites, :users

  def mock_message(stubs={})
    @mock_message ||= mock_model(Posting::Message, stubs)
  end
  
  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Wave::Conversation, stubs)
  end

  describe "requires a user" do
    it "redirects without a logged in user" do
      not_logged_in
      get :show, :wave_id => "37", :id => "42"
      response.should redirect_to(welcome_url)
    end
    
    it "is successful with a logged in user" do
      login(:friskyhands, :adam)
      get :show, :wave_id => "37", :id => "42"
      response.should be_successful
    end
  end
    
  describe "GET show" do    
    it "assigns the requested message as @posting" do
      pending
      login(:friskyhands, :adam).stub_chain(:conversations, :find_by_id).and_return(mock_conversation)
      mock_conversation.stub_chain(:postings, :find_by_id, :read).with('42').and_return(mock_message)
      get :show, { :wave_id => "37", :id => "42" }
      assigns[:posting].should equal(mock_message)
    end
    
    it "does not assign @posting when wave not found" do
      login(:friskyhands, :adam).stub_chain(:conversations, :find_by_id).and_return(nil)
      post :show, { :wave_id => "37", :id => "42" }
      assigns[:posting].should be_nil
    end

    it "does not assign @posting when posting not found" do
      pending
      login(:friskyhands, :adam).stub_chain(:conversations, :find_by_id).and_return(mock_conversation)
      mock_conversation.stub_chain(:postings, :find_by_id).and_return(nil)
      post :show, { :wave_id => "37", :id => "42" }
      assigns[:posting].should be_nil
    end
  end
  
  describe "POST create" do
    let(:adam) { users(:adam) }
    
    before(:each) do
      login(:friskyhands, :adam).stub_chain(:conversations, :find_by_id).and_return(mock_conversation.as_null_object)      
    end
    
    it "always renders create.js" do
      pending
      controller.stub(:broadcast_message)
      Posting::Message.stub(:new).and_return(mock_message.as_null_object)
      post :create, { :wave_id => "42", :format => "js" }
      response.should render_template('posting/messages/create')
    end
    
    describe "with valid params" do
      it "assigns a newly created message as @posting" do
        controller.stub(:broadcast_message)
        Posting::Message.should_receive(:new).with({ 'body' => 'hello world' }).and_return(mock_message.as_null_object)
        post :create, { :wave_id => "42", :posting_message => { 'body' => 'hello world' }}
        assigns[:posting].should equal(mock_message)
      end
  
      it "assigns sender, receiver and current_site to the message" do
        pending
        controller.stub(:broadcast_message)
        mock_conversation.stub(:receiver).and_return(users(:bert))
        Posting::Message.should_receive(:new).and_return(mock_message.as_null_object)
        mock_message.should_receive(:sender=).with(users(:adam))
        mock_message.should_receive(:receiver=).with(users(:bert))
        mock_message.should_receive(:site=).with(sites(:friskyhands))        
        post :create, { :wave_id => "42" }
      end
  
      it "broadcasts the message" do
        pending
        Posting::Message.stub(:new).and_return(mock_message(:waves => [ mock_conversation ]).as_null_object)
        controller.should_receive(:broadcast_posting).with(mock_message, [])
        post :create, { :wave_id => "42" }
      end
    end
  
    describe "with invalid params" do
      it "assigns a newly created but unsaved message as @posting" do        
        Posting::Message.stub(:new).and_return(mock_message(:valid? => false).as_null_object)
        post :create, { :wave_id => "42" }
        assigns[:posting].should equal(mock_message)
      end

      it "does not assign an invalid message to the wave's messages" do
        pending
        mock_conversation.stub(:messages).and_return(messages = double)
        Posting::Message.stub(:new).and_return(mock_message(:valid? => false).as_null_object)
        messages.should_not_receive(:<<)
        post :create, { :wave_id => "42" }        
      end
      
      it "@posting is not defined when wave not found" do
        adam.stub_chain(:conversations, :find_by_id).and_return(nil)
        assigns[:posting].should be_nil
        post :create, { :wave_id => "42" }        
      end      
    end  
  end
end

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
      get :show, :wave_id => "37", :id => "42"
      response.should redirect_to(welcome_url)
    end
    
    it "is successful with a logged in user" do
      login(:friskyhands, :adam)
      get :show, :wave_id => "37", :id => "42"
      response.should be_successful
    end
  end
  
  # describe "GET index" do
  #   it "assigns all messages as @messages" do
  #     Message.stub(:find).with(:all).and_return([mock_message])
  #     get :index
  #     assigns[:messages].should == [mock_message]
  #   end
  # end
  # 
  # describe "GET show" do
  #   it "assigns the requested message as @message" do
  #     Message.stub(:find).with("37").and_return(mock_message)
  #     get :show, :id => "37"
  #     assigns[:message].should equal(mock_message)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "assigns a new message as @message" do
  #     pending do
  #       Message.stub(:new).and_return(mock_message)
  #       get :new
  #       assigns[:message].should equal(mock_message)
  #     end
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested message as @message" do
  #     pending do
  #       Message.stub(:find).with("37").and_return(mock_message)
  #       get :edit, :id => "37"
  #       assigns[:message].should equal(mock_message)
  #     end
  #   end
  # end
  
  describe "POST create" do
    let(:adam) { users(:adam) }
    
    before(:each) do
      adam.stub_chain(:conversations, :find_by_id).and_return(mock_conversation.as_null_object)
      login(:friskyhands, :adam)
    end
    
    it "always renders create.js" do
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
        controller.stub(:broadcast_message)
        mock_conversation.stub(:receiver).and_return(users(:bert))
        Posting::Message.should_receive(:new).and_return(mock_message.as_null_object)
        mock_message.should_receive(:sender=).with(users(:adam))
        mock_message.should_receive(:receiver=).with(users(:bert))
        mock_message.should_receive(:site=).with(sites(:friskyhands))        
        post :create, { :wave_id => "42" }
      end
  
      it "broadcasts the message" do
        Posting::Message.stub(:new).and_return(mock_message(:waves => [ mock_conversation ]).as_null_object)
        controller.should_receive(:broadcast_posting).with(mock_message, [])
        post :create, { :wave_id => "42" }
      end
    end
  
    describe "with invalid params" do
  #     it "assigns a newly created but unsaved message as @message" do
  #       pending do
  #         Message.stub(:new).with({'these' => 'params'}).and_return(mock_message(:save => false))
  #         post :create, :message => {:these => 'params'}
  #         assigns[:message].should equal(mock_message)
  #       end
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       pending do
  #         Message.stub(:new).and_return(mock_message(:save => false))
  #         post :create, :message => {}
  #         response.should render_template('new')
  #       end
  #     end
    end  
  end
  
  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested message" do
  #       pending do
  #         Message.should_receive(:find).with("37").and_return(mock_message)
  #         mock_message.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :message => {:these => 'params'}
  #       end
  #     end
  # 
  #     it "assigns the requested message as @message" do
  #       pending do
  #         Message.stub(:find).and_return(mock_message(:update_attributes => true))
  #         put :update, :id => "1"
  #         assigns[:message].should equal(mock_message)
  #       end
  #     end
  # 
  #     it "redirects to the message" do
  #       pending do
  #         Message.stub(:find).and_return(mock_message(:update_attributes => true))
  #         put :update, :id => "1"
  #         response.should redirect_to(message_url(mock_message))
  #       end
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "updates the requested message" do
  #       pending do
  #         Message.should_receive(:find).with("37").and_return(mock_message)
  #         mock_message.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :message => {:these => 'params'}
  #       end
  #     end
  # 
  #     it "assigns the message as @message" do
  #       pending do
  #         Message.stub(:find).and_return(mock_message(:update_attributes => false))
  #         put :update, :id => "1"
  #         assigns[:message].should equal(mock_message)
  #       end
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       pending do
  #         Message.stub(:find).and_return(mock_message(:update_attributes => false))
  #         put :update, :id => "1"
  #         response.should render_template('edit')
  #       end
  #     end
  #   end
  # 
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested message" do
  #     pending do
  #       Message.should_receive(:find).with("37").and_return(mock_message)
  #       mock_message.should_receive(:destroy)
  #       delete :destroy, :id => "37"
  #     end
  #   end
  # 
  #   it "redirects to the messages list" do
  #     pending do 
  #       Message.stub(:find).and_return(mock_message(:destroy => true))
  #       delete :destroy, :id => "1"
  #       response.should redirect_to(messages_url)
  #     end
  #   end
  # end

end

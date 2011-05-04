require 'spec_helper'

describe Posting::InvitationsController do

  
  # let(:adam) { users(:adam) }
  
  # before(:each) { login(:friskyhands, :adam) }

  describe "GET 'create'" do
    it "should be successful" do
      pending
      get 'create'
      response.should be_success
    end
  end
  
  describe "PUT 'update'" do
    
    let(:wave) { mock_model(Wave::Invitation) }
    let(:invitation) { mock_model(Posting::Invitation, :email => 'adam@test.com', :update_attributes => true) }
    
    it "should redeliver mail if the email changes" do
      pending
      adam.stub!(:find_invitation_wave_by_id).and_return(wave)
      wave.stub_chain(:postings, :find_by_id).and_return(invitation)      
      put :update, :wave_id => wave.id, :id => invitation.id
    end
  end

end

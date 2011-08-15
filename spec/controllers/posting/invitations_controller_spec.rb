require 'spec_helper'

describe Posting::InvitationsController do
  
  context 'user not logged in' do
    describe "POST 'create'" do
      it 'should redirect to welcome page' do
        post :create, { :wave_id => '42' }
        response.should redirect_to(welcome_url)
      end
    end
    
    describe "PUT 'update'" do
      it 'should redirect to welcome page' do
        put :create, { :wave_id => '42', :id => '666' }
        response.should redirect_to(welcome_url)
      end
    end
  end
  
  context 'user logged in' do    
    let(:user) { stub_model(User, :handle => 'adam') }
    let(:site) { stub_model(Site, :name => 'mocksite', :display_name => 'Mock Site') }
    
    before(:each) do
      controller.stub(:current_user).and_return(user)
      controller.stub(:current_site).and_return(site)
    end
    
    describe "POST 'create'" do
      it 'should assign @li_eq' do
        post :create, { :wave_id => '42', :li_eq => '1' }
        assigns[:li_eq].should eq('1')
      end
      
      it 'should assign @posting with current_user and current_site' do
        post :create, { :wave_id => '42' }
        assigns[:posting].sponsor.should eq(user)
        assigns[:posting].site.should eq(site)
      end
      
      it "should assign @wave as user's invitation wave" do
        wave = double('wave').as_null_object
        user.stub!(:find_invitation_wave_by_id).with('42').and_return(wave)
        controller.stub!(:new_posting_invitation).and_return(double('posting').as_null_object)
        InvitationsMailer.stub_chain(:new_invitation_mail, :deliver)
        post :create, { :wave_id => '42' }
        assigns[:wave].should eq(wave)
      end
      
      it "should set @posting's state to offer" do
        posting = double('posting')        
        controller.stub!(:new_posting_invitation).and_return(posting)
        user.stub!(:find_invitation_wave_by_id).and_return(double('wave').as_null_object)
        InvitationsMailer.stub_chain(:new_invitation_mail, :deliver)
        posting.should_receive(:offer!)
        post :create, { :wave_id => '42' }        
      end
      
      it "should deliver invitation email" do        
        posting = stub_model(Posting::Invitation, :offer! => true, :email => 'adam@test.com', :sponsor => user, :site => site)
        controller.stub!(:new_posting_invitation).and_return(posting)
        user.stub!(:find_invitation_wave_by_id).and_return(double('wave').as_null_object)
        expect { post :create, { :wave_id => '42' }}.to change{ ActionMailer::Base.deliveries.size }.by(1)
      end      
    end
  
    describe "PUT 'update'" do
      it "should redeliver mail if the email changes" do
        posting = stub_model(Posting::Invitation, :update_attributes => true, :email_changed? => true, :sponsor => user, :site => site)
        wave = stub_model(Wave::Invitation)
        wave.stub_chain(:postings, :find_by_id).and_return(posting)
        user.stub!(:find_invitation_wave_by_id => wave)
        expect do
          put :update, { :wave_id => '42', :id => '666' }
        end.to change{ ActionMailer::Base.deliveries.size }.by(1)
      end
      
      it "should not redeliver mail if email doesn't change" do
        posting = stub_model(Posting::Invitation, :update_attributes => true, :email_changed? => false)
        wave = stub_model(Wave::Invitation)
        wave.stub_chain(:postings, :find_by_id).and_return(posting)
        user.stub!(:find_invitation_wave_by_id => wave)
        expect do
          put :update, { :wave_id => '42', :id => '666' }
        end.not_to change{ ActionMailer::Base.deliveries.size }
      end      
    end
  end

end

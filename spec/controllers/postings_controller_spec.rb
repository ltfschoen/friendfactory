require 'spec_helper'

describe PostingsController do

  def mock_posting(stubs={})
    @mock_posting ||= mock_model(Posting::Base, stubs)
  end

  # describe "GET index" do
  #   it "assigns all postings as @postings" do
  #     Posting::Base.stub(:find).with(:all).and_return([mock_posting])
  #     get :index
  #     assigns[:postings].should == [mock_posting]
  #   end
  # end
  # 
  # describe "GET show" do
  #   it "assigns the requested posting as @posting" do
  #     Posting::Base.stub(:find).with("37").and_return(mock_posting)
  #     get :show, :id => "37"
  #     assigns[:posting].should equal(mock_posting)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "assigns a new posting as @posting" do
  #     Posting::Base.stub(:new).and_return(mock_posting)
  #     get :new
  #     assigns[:posting].should equal(mock_posting)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested posting as @posting" do
  #     Posting::Base.stub(:find).with("37").and_return(mock_posting)
  #     get :edit, :id => "37"
  #     assigns[:posting].should equal(mock_posting)
  #   end
  # end
  # 
  # describe "POST create" do
  # 
  #   describe "with valid params" do
  #     it "assigns a newly created posting as @posting" do
  #       Posting::Base.stub(:new).with({'these' => 'params'}).and_return(mock_posting(:save => true))
  #       post :create, :posting => {:these => 'params'}
  #       assigns[:posting].should equal(mock_posting)
  #     end
  # 
  #     it "redirects to the created posting" do
  #       Posting::Base.stub(:new).and_return(mock_posting(:save => true))
  #       post :create, :posting => {}
  #       response.should redirect_to(posting_url(mock_posting))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved posting as @posting" do
  #       Posting.stub(:new).with({'these' => 'params'}).and_return(mock_posting(:save => false))
  #       post :create, :posting => {:these => 'params'}
  #       assigns[:posting].should equal(mock_posting)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       Posting.stub(:new).and_return(mock_posting(:save => false))
  #       post :create, :posting => {}
  #       response.should render_template('new')
  #     end
  #   end
  # 
  # end
  # 
  # describe "PUT update" do
  # 
  #   describe "with valid params" do
  #     it "updates the requested posting" do
  #       Posting.should_receive(:find).with("37").and_return(mock_posting)
  #       mock_posting.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :posting => {:these => 'params'}
  #     end
  # 
  #     it "assigns the requested posting as @posting" do
  #       Posting.stub(:find).and_return(mock_posting(:update_attributes => true))
  #       put :update, :id => "1"
  #       assigns[:posting].should equal(mock_posting)
  #     end
  # 
  #     it "redirects to the posting" do
  #       Posting.stub(:find).and_return(mock_posting(:update_attributes => true))
  #       put :update, :id => "1"
  #       response.should redirect_to(posting_url(mock_posting))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "updates the requested posting" do
  #       Posting.should_receive(:find).with("37").and_return(mock_posting)
  #       mock_posting.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :posting => {:these => 'params'}
  #     end
  # 
  #     it "assigns the posting as @posting" do
  #       Posting.stub(:find).and_return(mock_posting(:update_attributes => false))
  #       put :update, :id => "1"
  #       assigns[:posting].should equal(mock_posting)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Posting.stub(:find).and_return(mock_posting(:update_attributes => false))
  #       put :update, :id => "1"
  #       response.should render_template('edit')
  #     end
  #   end
  # 
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested posting" do
  #     Posting.should_receive(:find).with("37").and_return(mock_posting)
  #     mock_posting.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the postings list" do
  #     Posting.stub(:find).and_return(mock_posting(:destroy => true))
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(postings_url)
  #   end
  # end

end

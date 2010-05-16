require 'spec_helper'

describe FriendshipsController do

  def mock_friendship(stubs={})
    @mock_friendship ||= mock_model(Friendship, stubs)
  end

  describe "GET index" do
    it "assigns all friendships as @friendships" do
      pending
      Friendship.stub(:find).with(:all).and_return([mock_friendship])
      get :index
      assigns[:friendships].should == [mock_friendship]
    end
  end

  describe "GET show" do
    it "assigns the requested friendship as @friendship" do
      pending
      Friendship.stub(:find).with("37").and_return(mock_friendship)
      get :show, :id => "37"
      assigns[:friendship].should equal(mock_friendship)
    end
  end

  describe "GET new" do
    it "assigns a new friendship as @friendship" do
      pending
      Friendship.stub(:new).and_return(mock_friendship)
      get :new
      assigns[:friendship].should equal(mock_friendship)
    end
  end

  describe "GET edit" do
    it "assigns the requested friendship as @friendship" do
      pending
      Friendship.stub(:find).with("37").and_return(mock_friendship)
      get :edit, :id => "37"
      assigns[:friendship].should equal(mock_friendship)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created friendship as @friendship" do
        pending
        Friendship.stub(:new).with({'these' => 'params'}).and_return(mock_friendship(:save => true))
        post :create, :friendship => {:these => 'params'}
        assigns[:friendship].should equal(mock_friendship)
      end

      it "redirects to the created friendship" do
        pending
        Friendship.stub(:new).and_return(mock_friendship(:save => true))
        post :create, :friendship => {}
        response.should redirect_to(friendship_url(mock_friendship))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved friendship as @friendship" do
        pending
        Friendship.stub(:new).with({'these' => 'params'}).and_return(mock_friendship(:save => false))
        post :create, :friendship => {:these => 'params'}
        assigns[:friendship].should equal(mock_friendship)
      end

      it "re-renders the 'new' template" do
        pending
        Friendship.stub(:new).and_return(mock_friendship(:save => false))
        post :create, :friendship => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested friendship" do
        pending
        Friendship.should_receive(:find).with("37").and_return(mock_friendship)
        mock_friendship.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :friendship => {:these => 'params'}
      end

      it "assigns the requested friendship as @friendship" do
        pending
        Friendship.stub(:find).and_return(mock_friendship(:update_attributes => true))
        put :update, :id => "1"
        assigns[:friendship].should equal(mock_friendship)
      end

      it "redirects to the friendship" do
        pending
        Friendship.stub(:find).and_return(mock_friendship(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(friendship_url(mock_friendship))
      end
    end

    describe "with invalid params" do
      it "updates the requested friendship" do
        pending
        Friendship.should_receive(:find).with("37").and_return(mock_friendship)
        mock_friendship.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :friendship => {:these => 'params'}
      end

      it "assigns the friendship as @friendship" do
        pending
        Friendship.stub(:find).and_return(mock_friendship(:update_attributes => false))
        put :update, :id => "1"
        assigns[:friendship].should equal(mock_friendship)
      end

      it "re-renders the 'edit' template" do
        pending
        Friendship.stub(:find).and_return(mock_friendship(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested friendship" do
      pending
      Friendship.should_receive(:find).with("37").and_return(mock_friendship)
      mock_friendship.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the friendships list" do
      pending
      Friendship.stub(:find).and_return(mock_friendship(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(friendships_url)
    end
  end

end

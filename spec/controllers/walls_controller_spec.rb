require 'spec_helper'

describe Wall::WallsController do

  def mock_wall(stubs={})
    @mock_wall ||= mock_model(Wall, stubs)
  end

  describe "GET index" do
    it "assigns all walls as @walls" do
      Wall.stub(:find).with(:all).and_return([mock_wall])
      get :index
      assigns[:walls].should == [mock_wall]
    end
  end

  describe "GET show" do
    it "assigns the requested wall as @wall" do
      Wall.stub(:find).with("37").and_return(mock_wall)
      get :show, :id => "37"
      assigns[:wall].should equal(mock_wall)
    end
  end

  describe "GET new" do
    it "assigns a new wall as @wall" do
      Wall.stub(:new).and_return(mock_wall)
      get :new
      assigns[:wall].should equal(mock_wall)
    end
  end

  describe "GET edit" do
    it "assigns the requested wall as @wall" do
      Wall.stub(:find).with("37").and_return(mock_wall)
      get :edit, :id => "37"
      assigns[:wall].should equal(mock_wall)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created wall as @wall" do
        Wall.stub(:new).with({'these' => 'params'}).and_return(mock_wall(:save => true))
        post :create, :wall => {:these => 'params'}
        assigns[:wall].should equal(mock_wall)
      end

      it "redirects to the created wall" do
        Wall.stub(:new).and_return(mock_wall(:save => true))
        post :create, :wall => {}
        response.should redirect_to(wall_url(mock_wall))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved wall as @wall" do
        Wall.stub(:new).with({'these' => 'params'}).and_return(mock_wall(:save => false))
        post :create, :wall => {:these => 'params'}
        assigns[:wall].should equal(mock_wall)
      end

      it "re-renders the 'new' template" do
        Wall.stub(:new).and_return(mock_wall(:save => false))
        post :create, :wall => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested wall" do
        Wall.should_receive(:find).with("37").and_return(mock_wall)
        mock_wall.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wall => {:these => 'params'}
      end

      it "assigns the requested wall as @wall" do
        Wall.stub(:find).and_return(mock_wall(:update_attributes => true))
        put :update, :id => "1"
        assigns[:wall].should equal(mock_wall)
      end

      it "redirects to the wall" do
        Wall.stub(:find).and_return(mock_wall(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(wall_url(mock_wall))
      end
    end

    describe "with invalid params" do
      it "updates the requested wall" do
        Wall.should_receive(:find).with("37").and_return(mock_wall)
        mock_wall.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wall => {:these => 'params'}
      end

      it "assigns the wall as @wall" do
        Wall.stub(:find).and_return(mock_wall(:update_attributes => false))
        put :update, :id => "1"
        assigns[:wall].should equal(mock_wall)
      end

      it "re-renders the 'edit' template" do
        Wall.stub(:find).and_return(mock_wall(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested wall" do
      Wall.should_receive(:find).with("37").and_return(mock_wall)
      mock_wall.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the walls list" do
      Wall.stub(:find).and_return(mock_wall(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(walls_url)
    end
  end

end

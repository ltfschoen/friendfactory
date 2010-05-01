class FriendshipsController < ApplicationController

  before_filter :require_user
  
  # GET /friendships
  # GET /friendships.xml
  # def index
  #   @friendships = Friendship.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @friendships }
  #   end
  # end

  # GET /friendships/1
  # GET /friendships/1.xml
  # def show
  #   @friendship = Friendship.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @friendship }
  #   end
  # end

  # GET /friendships/new
  # GET /friendships/new.xml
  # def new
  #   @friendship = Friendship.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @friendship }
  #   end
  # end

  # GET /friendships/1/edit
  # def edit
  #   @friendship = Friendship.find(params[:id])
  # end

  def create
    unless params[:friend_id] == current_user.id
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    end
    respond_to do |format|
      if @friendship.try(:save)
        format.html { redirect_to(@friendship) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /friendships/1
  # PUT /friendships/1.xml
  # def update
  #   @friendship = Friendship.find(params[:id])
  #   respond_to do |format|
  #     if @friendship.update_attributes(params[:friendship])
  #       flash[:notice] = 'Friendship was successfully updated.'
  #       format.html { redirect_to(@friendship) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @friendship.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to(friendships_url) }
    end
  end
end

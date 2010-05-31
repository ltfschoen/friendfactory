class FriendshipsController < ApplicationController

  before_filter :require_user

  def create    
    @friend = User.find_by_id(params[:friend_id])
    if @friend != current_user
      friendship = current_user.friendships.create(:friend => @friend)
      @posting = friendship.posting if friendship
    end
    respond_to do |format|
      format.js
    end
  end

  # def destroy
  #   @friendship = current_user.friendships.find(params[:id])
  #   @friendship.destroy
  #   respond_to do |format|
  #     format.html { redirect_to(friendships_url) }
  #   end
  # end

end

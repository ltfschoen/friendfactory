class Waves::ConversationsController < ApplicationController

  before_filter :require_user

  def show
    @wave = nil
    if params[:profile_id]
      user = Wave::Profile.find_by_id(params[:profile_id]).try(:user)
      @wave = current_user.conversation.with(user) if user
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def index
    @waves = current_user.conversations
    respond_to do |format|
      format.html
    end
  end
  
end

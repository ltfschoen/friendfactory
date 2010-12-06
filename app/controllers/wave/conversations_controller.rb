class Wave::ConversationsController < ApplicationController

  before_filter :require_user

  def index
    @waves = current_user.conversations
    respond_to do |format|
      format.html
    end
  end

  def show
    user = Wave::Profile.find_by_id(params[:profile_id]).try(:user)
    @wave = current_user.conversation.with(user) || current_user.create_conversation_with(user)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
end

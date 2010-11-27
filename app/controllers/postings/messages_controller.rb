class Postings::MessagesController < ApplicationController

  before_filter :require_user

  def create
    @posting = nil
    
    # The receiver is carried in as profile_id in the params
    # from the polaroid. Convert this to user_id.
    profile_id = params[:posting_message].delete(:profile_id)    
    receiver = Wave::Profile.find_by_id(profile_id).try(:user)
    
    if receiver
      wave = current_user.conversations.with(receiver) || current_user.create_conversation_with(receiver)
      
      posting_message = params[:posting_message].merge({:user_id => current_user.id, :receiver_id => receiver.id })
      @posting = wave.messages.create(posting_message)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end

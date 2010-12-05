class Posting::MessagesController < ApplicationController

  before_filter :require_user

  def create
    # From the polaroid, the receiver is carried in as
    #   profile_id in the params. Convert this to user_id.
    # From the inbox, the receiver is carried in the
    #   wave_id on the path.

    @wave = nil
    @posting = nil
    
    if params[:wave_id]
      @wave = current_user.conversations.find_by_id(params[:wave_id])
      if @wave
        posting_message = params[:posting_message].merge({ :user_id => current_user.id, :receiver_id => @wave.recipient.id })
      end        
    else
      profile_id = params[:profile_id]
      receiver = Wave::Profile.find_by_id(profile_id).try(:user)    
      if receiver
        @wave = current_user.conversation.with(receiver) || current_user.create_conversation_with(receiver)      
        posting_message = params[:posting_message].merge({ :user_id => current_user.id, :receiver_id => receiver.id })
      end
    end

    @posting = @wave.messages.create(posting_message)
    
    (@posting.waves - [ @wave ]).each do |wave|
      channel_id = dom_id(wave)
      Pusher[channel_id].trigger('message', { :url => wave_posting_message_path(wave, @posting), :dom_id => "##{channel_id}" })
    end
    
    respond_to do |format|
      format.js { render(:layout => false) }
    end
  end
  
  def show
    @posting = nil
    wave = current_user.conversations.find_by_id(params[:wave_id])
    if wave
      @posting = wave.postings.find_by_id(params[:id])
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end

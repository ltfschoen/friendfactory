class Posting::MessagesController < ApplicationController

  before_filter :require_user

  def show
    wave = current_user.conversations.site(current_site).find_by_id(params[:wave_id])
    @posting = wave.postings.find_by_id(params[:id]) if wave.present?
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create    
    if @wave = current_user.conversations.site(current_site).find_by_id(params[:wave_id])
      posting_message_params = params[:posting_message].merge(:sender => current_user, :receiver => @wave.recipient, :site => current_site)
      @posting = @wave.messages.create(posting_message_params)
      broadcast_posting(@posting, (@posting.waves - [ @wave ]))
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  private
  
  def broadcast_posting(posting, waves)
    waves.each do |wave|
      channel_id = dom_id(wave)
      Pusher[channel_id].trigger('message', { :url => wave_posting_message_path(wave, posting), :dom_id => "##{channel_id}" })
    end
  end
  
end

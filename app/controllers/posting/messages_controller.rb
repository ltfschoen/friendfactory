class Posting::MessagesController < ApplicationController

  before_filter :require_user

  def show
    if wave = current_user.conversations.find_by_id(params[:wave_id])
      @posting = wave.postings.find_by_id(params[:id])
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    if @wave = current_user.conversations.find_by_id(params[:wave_id])
      @posting = Posting::Message.new(params[:posting_message]).tap do |posting|
        posting.sender = current_user
        posting.receiver = @wave.recipient
        posting.site = current_site
        posting.state = :published
      end
      if @posting.save
        @wave.messages << @posting
        broadcast_posting(@posting, (@posting.waves - [ @wave ]))
      end
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
    receiver = posting.receiver
    if !receiver.online? && receiver.emailable?
      MessagesMailer.new_message_notification(posting).deliver
    end    
  end
  
end

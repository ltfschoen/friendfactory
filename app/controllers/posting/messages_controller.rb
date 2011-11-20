class Posting::MessagesController < ApplicationController

  before_filter :require_user

  def show
    if wave = current_user.conversations.find_by_id(params[:wave_id])
      wave.read!
      @last_read_at = wave.read_at
      @posting = wave.postings.find_by_id(params[:id])
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    respond_to do |format|
      success = false
      if @wave = current_user.conversations.find_by_id(params[:wave_id])
        @posting = Posting::Message.new(params[:posting_message]) { |posting| initialize_message(posting, @wave.recipient) }
        if success = @posting.save && add_message_to_conversation(@posting, @wave)
          conversations = @posting.waves(true).except(@wave)
          broadcast_posting(@posting, conversations)
        end
      end
      format.json { render :json => { :success => success }}
    end
  end

  private

  def initialize_message(posting, recipient)
    posting.site = current_site
    posting.sender = current_user
    posting.receiver = recipient
  end

  def add_message_to_conversation(posting, wave)
    wave.postings << posting
    wave.read! && posting.publish!
  rescue
    false
  end

  def broadcast_posting(posting, waves)
    broadcast_posting_via_pusher(posting, waves)
    broadcast_posting_via_email(posting)
  end

  def broadcast_posting_via_pusher(posting, waves)
    waves.each do |wave|
      channel_id = dom_id(wave)
      Pusher[channel_id].trigger('message', { :url => wave_posting_message_path(wave, posting), :dom_id => "##{channel_id}" })
    end
  end

  def broadcast_posting_via_email(posting)
    receiver = posting.receiver
    if !receiver.online? && receiver.emailable?
      MessagesMailer.new_message_notification(posting).deliver
    end
  end

end

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
      wave = current_user.conversations.find(params[:wave_id])
      if posting = add_message_to_conversation(new_message(wave.recipient), wave)
        broadcast_posting(posting)
        format.json { render :json => { :success => true }}
      else
        format.json { render :json => { :success => false }}
      end
    end
  end

  private

  def new_message(receiver)
    @new_message ||= begin
      Posting::Message.published.user(current_user).new(params[:posting_message]) do |posting|
        posting.site     = current_site
        posting.receiver = receiver
      end
    end
  end

  def add_message_to_conversation(posting, wave)
    ActiveRecord::Base.transaction do
      if wave.postings << posting
        wave.mark_as_read
      end
    end
    posting
  end

  def broadcast_posting(posting)
    broadcast_posting_via_pusher(posting)
    broadcast_posting_via_email(posting)
  end

  def broadcast_posting_via_pusher(posting)
    wave = posting.receiver_wave
    channel_id = dom_id(wave)
    Pusher[channel_id].trigger('message', { :url => wave_posting_message_path(wave, posting), :dom_id => "##{channel_id}" })
  end

  def broadcast_posting_via_email(posting)
    if receiver = posting.receiver
      if (receiver.offline? && receiver.emailable?) || Rails.env.development?
        PostingsMailer.delay.new_message_notification(posting, current_site, request.host, request.port)
      end
    end
  end

end

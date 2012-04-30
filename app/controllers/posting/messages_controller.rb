class Posting::MessagesController < ApplicationController

  before_filter :require_user

  helper_method :wave, :posting

  after_filter :notify, :only => [ :create ]

  def show
    respond_to do |format|
      wave.read!
      format.html { render :layout => false }
    end
  end

  def create
    respond_to do |format|
      if wave.postings << new_message
        wave.mark_as_read
        format.json { render :json => { :success => true }}
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  def wave
    @wave ||= begin
      current_user.conversations.find(params[:wave_id])
    end
  end

  def posting
    @posting ||= begin
      wave.postings.find(params[:id])
    end
  end

  def new_message
    @new_message ||= begin
      Posting::Message.published.user(current_user).new(params[:posting_message])
    end
  end

  ###

  def notify
    if new_message.persisted?
      notify_via_pusher
      notify_via_mailer
    end
  end

  def notify_via_pusher
    wave = new_message.receiver_wave
    channel_id = dom_id(wave)
    Pusher[channel_id].trigger('message', { :url => wave_posting_message_path(wave, new_message), :dom_id => "##{channel_id}" })
  end

  def notify_via_mailer
    new_message.subscriptions.notify do |subscriber|
      Posting::MessagesMailer.delay.create(subscriber, new_message, current_site, request.host, request.port)
    end
  end

end

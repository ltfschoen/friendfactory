require 'pusher'

class Posting::ChatsController < ApplicationController

  def index
  end
  
  def create
    channel = params[:channel]
    Pusher[channel].trigger('bubble', { :body => params[:posting_chat][:body] })
    respond_to do |format|
      format.js
    end
  end
  
end

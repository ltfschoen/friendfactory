class Waves::ConversationsController < ApplicationController

  before_filter :require_user

  def index
    @waves = current_user.conversations
  end
  
end

class Waves::ConversatonsController < ApplicationController

  before_filter :require_user

  def index
    @waves = current_user.conversations
  end
  
end

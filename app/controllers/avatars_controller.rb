class AvatarsController < ApplicationController

  before_filter :require_user

  def create
    @avatar = Posting::Avatar.new(params[:posting_avatar])
    current_user.profile.avatars << @avatar rescue nil
    respond_to_parent do
      respond_to do |format|
        format.js
      end
    end    
  end
  
end

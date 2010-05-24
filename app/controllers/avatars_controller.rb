class AvatarsController < ApplicationController

  before_filter :require_user

  def create
    @avatar = Posting::Avatar.new(params[:posting_avatar].merge(:active => true))
    current_user.postings << @avatar
    current_user.profile.avatars << @avatar
    respond_to_parent do
      respond_to do |format|
        format.js
      end
    end
  end
  
end

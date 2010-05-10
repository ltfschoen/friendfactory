class TextsController < ApplicationController

  before_filter :require_user
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])    
    @posting = Posting::Text.create(params[:posting_text].merge({ :wave_id => wave, :user_id => current_user }))
    respond_to do |format|
      format.js
    end
  end

end

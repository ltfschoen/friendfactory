class PersonagesController < ApplicationController

  before_filter :require_user

  def switch
    if @personage = current_user_session.record.personages.find_by_id(params[:id])
      session[:personage_id] = @personage.id
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
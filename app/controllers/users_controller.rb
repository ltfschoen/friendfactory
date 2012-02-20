class UsersController < ApplicationController

  before_filter :require_user

  def destroy
    User.transaction { current_user_record.disable! }
    respond_to do |format|
      format.html { redirect_to welcome_url }
    end
  end

end

class Admin::UsersController < ApplicationController

  before_filter :require_admin
  helper_method :site, :user, :page_title

  layout 'admin/site'

  def index
    respond_to do |format|
      format.html { render }
    end
  end

  def update
    respond_to do |format|
      format.json { render :json => update_user_role }
    end
  end

  private

  def site
    @site ||= Site.find(params[:site_id])
  end

  def user
    @user ||= site.users.find(params[:id]) if site
  end

  def page_title
    "#{site.display_name} - Users"
  end
  
  def update_user_role
    if user
      user.update_attributes(params[:user])
      if Role.values.include?(params[:user][:role])
        user.role = params[:user][:role]
        user.save!
      end
    end
  end

end

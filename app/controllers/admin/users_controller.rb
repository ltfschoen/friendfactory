class Admin::UsersController < ApplicationController

  before_filter :require_admin
  helper_method :site, :user, :users, :page_title

  layout 'admin/site'

  def index
    respond_to do |format|
      format.html { render }
    end
  end

  def update
    respond_to do |format|
      format.json { render :json => update_user }
    end
  end

  private

  def site
    @site ||= Site.find(params[:site_id])
  end

  def user
    @user ||= site.users.find(params[:id]) if site
  end

  def users
    @users ||= site.users.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def page_title
    "#{site.display_name} - Users"
  end
  
  def update_user
    if user
      if current_user.administrator? && role_name = params[:user].delete(:role)
        user.role = role_name
      end
      user.update_attributes(params[:user])
    end
  end

end

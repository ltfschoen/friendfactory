class Admin::UsersController < ApplicationController

  before_filter :require_admin
  helper_method :site, :user, :users
  helper_method :page_title

  layout 'admin/site'

  def index
    respond_to do |format|
      format.html { render }
    end
  end

  def update
    user.role_id = params[:user].delete(:role_id) || user.role_id
    respond_to do |format|
      format.json { render :json => user.update_attributes(params[:user]) }
    end
  end

  private

  def site
    @site ||= Site.find(params[:site_id])
  end

  def user
    @user ||= site.users.find(params[:id])
  end

  def users
    @users ||= site.users.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def page_title
    "#{site.display_name} - Users"
  end

end

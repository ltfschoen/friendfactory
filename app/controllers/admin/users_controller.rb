class Admin::UsersController < ApplicationController

  before_filter :require_admin

  helper_method \
      :site,
      :user,
      :users,
      :page_title

  layout 'admin'

  def index
    respond_to do |format|
      format.html { render }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
    end
  end

  def update
    respond_to do |format|
      format.json { render :json => { :ok => user.update_attributes(params[:user], :as => :admin) }}
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

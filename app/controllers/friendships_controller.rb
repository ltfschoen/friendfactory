class FriendshipsController < ApplicationController

  before_filter :require_user

  cattr_reader :per_page

  def index
    @@per_page = 102
    @waves = current_user.friends.site(current_site).published.order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
    respond_to do |format|
      format.html
    end
  end

  def buddy
    respond_to do |format|
      if profile = current_site.waves.type(Wave::Profile).find_by_id(params[:id])
        format.json { render :json => { :buddied => current_user.toggle_friendship(profile) }}
      end
    end
  end

end

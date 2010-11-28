class Waves::RollCallsController < Waves::BaseController

  before_filter :require_lurker

  def index
    @waves = if params[:tag]
      params[:tag] = params[:tag].downcase.gsub(/-/, ' ')
      UserInfo.tagged_with(params[:tag]).map(&:profile)
    else
      Wave::Profile.includes(:resource, :avatars).order('updated_at desc')
    end
    @tags = UserInfo.tag_counts_on(:tags).order('name asc')
    respond_to do |format|
      format.html
    end
  end

end

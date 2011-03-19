class Wave::RollCallsController < ApplicationController
  
  before_filter :require_lurker

  cattr_reader :per_page
  @@per_page = 102
  
  def index
    @waves = if params[:tag]
      params[:tag] = params[:tag].downcase.gsub(/-/, ' ')
      UserInfo.
          tagged_with(params[:tag]).
          includes(:profile).
          where(:waves => { :state => :published }).
          order('waves.updated_at desc').
          map(&:profile).
          paginate(:page => params[:page], :per_page => @@per_page)
    else
      current_site.waves.type(Wave::Profile).
          where(:state => :published).
          includes(:avatars).
          order('updated_at desc').
          paginate(:page => params[:page], :per_page => @@per_page)
    end
    @tags = UserInfo.tag_counts_on(:tags).order('name asc')
    respond_to do |format|
      format.html
    end
  end

end

class Wave::EventsController < ApplicationController

  DefaultEventSlug = 'events'
  
  before_filter :require_lurker

  cattr_reader :per_page
  @@per_page = 30
  
  def index
    @waves = if params[:tag]
      params[:tag] = params[:tag].downcase.gsub(/-/, ' ')
      Wave::Event \
        .tagged_with(params[:tag]) \
        .where(:state => :published) \
        .order('updated_at desc') \
        .paginate(:page => params[:page], :per_page => @@per_page)
    else
      Wave::Event.where(:state => :published).order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
    end
    @tags = Wave::Event.tag_counts_on(:tags).order('name asc')
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @wave = Wave::Event.new(params[:wave_event])
    @wave.user = current_user
    @wave.save
    respond_to do |format|
      format.js { render :layout => false }
    end
  end  
  
end

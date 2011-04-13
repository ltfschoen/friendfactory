class Wave::EventsController < ApplicationController

  DefaultEventSlug = 'events'
  
  cattr_reader :per_page
  @@per_page = 30
  
  def index
    @waves = find_events_tagged_with(params[:tag]) || find_all_events
    @tags = tag_counts_on_current_site
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @wave = Wave::Event.new(params[:wave_event])
    @wave.user = current_user
    respond_to do |format|
      if current_site.waves << @wave
        format.js { render :layout => false }
      end
    end
  end
  
  private
  
  def find_events_tagged_with(tag)
    return unless tag.present?
    Wave::Event.tagged_with(scrubbed_tag(tag), :on => current_site).
        where(:state => :published).
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)
  end
  
  def find_all_events
    current_site.waves.type(Wave::Event).published.
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)      
  end
  
  def scrubbed_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end
  
  def tag_counts_on_current_site
    Wave::Event.tag_counts_on(current_site).order('name asc')
  end
  
end

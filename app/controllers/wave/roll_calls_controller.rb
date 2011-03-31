class Wave::RollCallsController < ApplicationController
  
  before_filter :require_user

  cattr_reader :per_page
  @@per_page = 102
  
  def index
    @waves = find_profiles_tagged_with(params[:tag]) || find_all_profiles
    @tags = tag_counts_for_current_site
    respond_to do |format|
      format.html
    end
  end
  
  private

  def find_profiles_tagged_with(tag)
    return unless tag.present?
    Wave::Profile.tagged_with(scrubbed_tag(tag), :on => current_site).
        where(:state => :published).
        includes(:avatars).
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)
  end
  
  def find_all_profiles
    current_site.waves.type(Wave::Profile).
        where(:state => :published).
        includes(:avatars).
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)    
  end
  
  def tag_counts_for_current_site
    Wave::Profile.tag_counts_on(current_site).order('name asc')
  end
  
  def scrubbed_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

end

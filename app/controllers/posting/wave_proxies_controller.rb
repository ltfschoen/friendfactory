class Posting::WaveProxiesController < ApplicationController

  before_filter :require_user

  def create
    if @wave = current_site.waves.find_by_id(params[:wave_id])
      @wave.postings << new_posting_wave_proxy
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def album
    @photos = []
    if @proxy = Posting::Base.find_by_id(params[:id])
      @photos = @proxy.resource.photos
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  private
  
  def new_posting_wave_proxy
    if resource = current_site.waves.find_by_id(params[:resource_id])
      resource.publish!
      @posting = Posting::WaveProxy.new do |proxy|
        proxy.site = current_site
        proxy.user = current_user
        proxy.sticky_until = params[:sticky_until] if current_user.admin?
        proxy.resource = resource
        proxy.state = :published
      end
    end
  end

end

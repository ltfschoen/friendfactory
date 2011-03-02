class Posting::WaveProxiesController < ApplicationController

  def create
    wave.postings << new_posting_wave_proxy if wave.present?
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  private
  
  def wave
    @wave ||= Wave::Base.find_by_id(params[:wave_id])
  end
  
  def new_posting_wave_proxy
    if resource = Wave::Base.find_by_id(params[:resource_id])
      resource.publish!
      @posting = Posting::WaveProxy.new.tap do |proxy|
        proxy.user = current_user
        proxy.resource = resource
        proxy.state = :published
      end
    end
  end

end

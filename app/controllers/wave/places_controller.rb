class Wave::PlacesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user
  helper_method :wave, :postings, :persona

  layout 'wave/conversation'

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html do
        render
      end
    end
  end

  private
  
  def wave
    # TODO Rescue from find exception
    current_site.waves.type(Wave::Place).find(params[:id])
  end
  
  memoize :wave

  def postings
    wave.postings.published.order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end
  
  memoize :postings
  
  def persona
    wave.persona
  end

  memoize :persona

end

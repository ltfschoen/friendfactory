class Wave::PlacesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user
  helper_method :wave, :profile, :postings

  layout 'wave/conversation'

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html { render }
    end
  end

  private

  def wave
    # TODO Rescue from find exception
    current_site.waves.type(Wave::Place).includes(:user => :persona).find(params[:id])
  end
  
  alias :profile :wave

  memoize :wave

  def postings
    wave.postings.published.order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

end

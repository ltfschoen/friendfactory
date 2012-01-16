class Wave::PlacesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings
  helper_method :page_title

  layout 'wave/community'

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html
    end
  end

  private

  def wave
    # TODO Rescue from find exception
    current_site.waves.type(Wave::Place).includes(:user => :persona).find(params[:id])
  end

  memoize :wave

  def postings
    wave.postings.published.order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def page_title
    wave.user.handle
  end

end

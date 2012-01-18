class Wave::PlacesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings
  helper_method :page_title

  layout 'three-column'

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
    wave.postings.
      published.
      order('`postings`.`updated_at` DESC').
      includes(:user => :persona).
      includes(:user => :profile).
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def page_title
    "#{current_site.display_name} - #{wave.handle}"
  end

end

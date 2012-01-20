require 'render_headshot'

class Wave::PlacesController < ApplicationController

  include RenderHeadshot

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings
  helper_method :page_title

  layout 'three-column'

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html { request.xhr? ? render_headshot(params[:id]) : render }
    end
  end

  private

  def wave
    current_site.waves.published.type(Wave::Place).includes(:user => :persona).find(params[:id])
  end

  memoize :wave

  def postings
    wave.postings.
      published.
      order('`postings`.`updated_at` DESC').
      includes(:user => { :persona => :avatar }).
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def page_title
    "#{current_site.display_name} - #{wave.handle}"
  end

end

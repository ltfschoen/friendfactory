require 'resolver'
require 'render_headshot'

class Wave::AmbassadorsController < ApplicationController

  include RenderHeadshot

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings
  helper_method :page_title

  layout 'community'

  prepend_view_path ::Resolver.new('wave/ambassadors')

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html { request.xhr? ? render_headshot(params[:id]) : render }
    end
  end

  private

  def wave
    current_site.waves.type(Wave::Ambassador).includes(:user => :persona).find(params[:id])
  end

  memoize :wave

  def postings
    wave.postings.published.
      includes(:user => { :persona => :avatar }).
      order('`sticky_until` DESC, `updated_at` DESC').
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def page_title
    "#{current_site.display_name} - #{wave.handle}"
  end

end

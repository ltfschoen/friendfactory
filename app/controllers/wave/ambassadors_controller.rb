require 'resolver'

class Wave::AmbassadorsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user
  helper_method :wave, :postings, :persona

  layout 'wave/profile'

  prepend_view_path ::Resolver.new('wave/ambassadors')

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
    current_site.waves.type(Wave::Ambassador).find(params[:id])
  end

  memoize :wave

  def postings
    wave.postings.published.order('`postings`.`updated_at` DESC').paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def persona
    wave.persona
  end

  memoize :persona

end

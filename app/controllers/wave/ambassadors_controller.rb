require 'resolver'

class Wave::AmbassadorsController < ApplicationController

  before_filter :require_user
  helper_method :person, :wave, :profile, :postings

  layout 'wave/profile'

  prepend_view_path ::Resolver.new('wave/ambassadors')

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
    @wave ||= current_site.waves.type(Wave::Ambassador).find_by_id(params[:id])
  end

  alias :profile :wave

  def postings
    if wave
      @postings ||= wave.postings.
          published.
          order('`postings`.`updated_at` DESC').
          paginate(:page => params[:page], :per_page => @@per_page)
    end
  end

  def person
    @person ||= wave.person if wave
  end

end

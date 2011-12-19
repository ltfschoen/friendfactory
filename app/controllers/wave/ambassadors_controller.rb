class Wave::AmbassadorsController < ApplicationController
  
  before_filter :require_user
  helper_method :person, :wave, :profile, :postings

  layout 'wave/ambassador'

  cattr_reader :per_page

  def show
    @@per_page = 50
    respond_to do |format|
      format.html do
        render
      end
    end
  end

  ### Pane

  def headshot
    respond_to do |format|
      format.html { render :partial => 'headshot', :locals => { :profile => wave } }
    end
  end

  def signals
    @profile = Wave::Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def biometrics
    @profile = Wave::Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def photos
    @wave = Wave::Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
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

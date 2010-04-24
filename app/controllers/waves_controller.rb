class WavesController < ApplicationController

  before_filter :require_lurker

  # def index
  #   @waves = Wave.all
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @waves }
  #   end
  # end

  def show
    @wave = Wave::Base::find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def popular
    @wave = Wave::Base::popular
    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end

  # GET /waves/new
  # GET /waves/new.xml
  # def new
  #   @wave = Wave.new
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @wave }
  #   end
  # end

  # GET /waves/1/edit
  # def edit
  #   @wave = Wave.find(params[:id])
  # end

  # POST /waves
  # POST /waves.xml
  # def create
  #   @wave = Wave.new(params[:wave])
  #   respond_to do |format|
  #     if @wave.save
  #       flash[:notice] = 'Wave was successfully created.'
  #       format.html { redirect_to(@wave) }
  #       format.xml  { render :xml => @wave, :status => :created, :location => @wave }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @wave.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /waves/1
  # PUT /waves/1.xml
  # def update
  #   @wave = Wave.find(params[:id])
  #   respond_to do |format|
  #     if @wave.update_attributes(params[:wave])
  #       flash[:notice] = 'Wave was successfully updated.'
  #       format.html { redirect_to(@wave) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @wave.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /waves/1
  # DELETE /waves/1.xml
  # def destroy
  #   @wave = Wave.find(params[:id])
  #   @wave.destroy
  #   respond_to do |format|
  #     format.html { redirect_to(waves_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end

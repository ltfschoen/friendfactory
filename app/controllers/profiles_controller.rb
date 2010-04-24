class ProfilesController < ApplicationController

  before_filter :require_user
  
  # def index
  #   @profiles = Profile.all
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @profiles }
  #   end
  # end

  def show
    # @profile = current_user.profile
    # current_user.save && current_user.reload if @profile.nil?
    # respond_to do |format|
    #   format.html
    # end
  end

  # def new
  #   @profile = Profile.new
  #   respond_to do |format|
  #     format.html
  #   end
  # end

  def edit
    @profile = current_user.profile
    current_user.save && current_user.reload if @profile.nil?
    respond_to do |format|
      format.html
    end
  end

  def create
    @profile = current_user.profile
    @profile.build_avatar(params[:posting_avatar])
    respond_to_parent do
      respond_to do |format|
        if @profile.save
          format.js
        else
          format.js { render :action => "error" }
        end
      end
    end
  end

  # def update
  #   @profile = current_user.profile
  #   @profile.build_avatar(params[:posting_avatar])
  #   respond_to_parent do
  #     respond_to do |format|
  #       if @profile.save
  #         format.js
  #       else
  #         format.js { render :action => "error" }
  #       end
  #     end
  #   end
  # end

  # def destroy
  #   @profile = Profile.find(params[:id])
  #   @profile.destroy
  #   respond_to do |format|
  #     format.html { redirect_to(profiles_url) }
  #   end
  # end  
end

class WelcomeController < ApplicationController

  before_filter :require_no_user

  def register
    scrub_params params[:user], :first_name, :last_name, :email
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        Pusher['wave'].trigger('user-register', { :full_name => @user.full_name })      
        format.html { redirect_to edit_profile_path}
      else
        flash[:signup] = true
        @user_session  = UserSession.new
        format.html { render :action => :index }
      end
    end
  end
  
  def login
    scrub_params params[:user_session], :email
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        user = @user_session.record
        avatar = user.profile.avatar
        Pusher['wave'].trigger('user-online', {
            :full_name => user.full_name,
            :avatar    => {
                :id        => avatar.try(:id),
                :file_name => avatar.try(:image_file_name) }})
        flash[:notice] = "Login successful!"
        format.html { redirect_to root_path }
      else
        @user = User.new
        format.html { render :action => :index }
      end
    end
  end
  
  def lurk
    session[:lurker] = true
    respond_to do |format|
      Pusher['wave'].trigger('lurker-online', {})
      format.html { redirect_to root_path }
    end
  end
  
  private
  
  def scrub_params(object_hash, *methods)
    methods.each do |method|
      method = method.to_sym
      if object_hash.try(:[], method) == helpers.placeholder_for(method)
        object_hash[method] = nil 
      end    
    end
  end

end

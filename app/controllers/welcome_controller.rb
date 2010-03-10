class WelcomeController < ApplicationController

  before_filter :require_no_user

  def new
    @user = User.new
    @user_session = UserSession.new
  end
  
  def register
    scrub_params params[:user], :first_name, :last_name, :email
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path }
      else
        flash[:signup] = true
        @user_session  = UserSession.new
        format.html { render :action => 'new' }
      end
    end
  end
  
  def login
    scrub_params params[:user_session], :email
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        flash[:notice] = "Login successful!"        
        format.html { redirect_to root_path }
      else
        @user = User.new
        format.html { render :action => :new }
      end
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

class UsersController < ApplicationController

  before_filter :require_user

  def index
  end

  def show
    @profile = current_user    
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end

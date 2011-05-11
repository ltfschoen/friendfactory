class Admin::Invitation::UniversalsController < ApplicationController

  before_filter :require_admin
  
  def index
    @postings = Posting::Invitation.universal.site(current_site).order('created_at desc')
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @posting = new_posting_invitation
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @posting = new_posting_invitation(params[:posting_invitation])
    respond_to do |format|
      if @posting.save
        @posting.offer!
        format.html { redirect_to admin_invitation_universals_path }
      else
        format.html { render :action => 'new' }
      end
    end    
  end
  
  def edit
    @posting = Posting::Invitation.universal.site(current_site).find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @posting = Posting::Invitation.universal.site(current_site).find_by_id(params[:id])
    respond_to do |format|
      if @posting && @posting.update_attributes(params[:posting_invitation])
        format.html { redirect_to admin_invitation_universals_path }
        format.json { render :json => { :updated => true }}
      else
        format.html { render :action => 'edit' }
        format.json { render :json => { :updated => false }}
      end
    end
  end
  
  private
  
  def new_posting_invitation(attrs = {})
    Posting::Invitation.universal.new(attrs).tap do |invitation|
      invitation.sponsor = current_user
      invitation.site = current_site
    end
  end

end

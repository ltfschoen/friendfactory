class Posting::InvitationsController < ApplicationController
  
  def create
    @li_eq = params[:li_eq]
    @posting = new_posting_invitation
    if @wave = current_user.find_invitation_wave_by_id(params[:wave_id])
      @wave.postings << @posting
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @li_eq = params[:li_eq]
    if @wave = current_user.find_invitation_wave_by_id(params[:wave_id])
      @posting = @wave.postings.find_by_id(params[:id])
      @posting.try(:update_attributes, params[:posting_invitation])
    end
    respond_to do |format|
      format.js { render :action => 'create', :layout => false }
    end
  end
    
  private

  def new_posting_invitation
    Posting::Invitation.new(params[:posting_invitation]).tap do |posting|
      posting.sponsor = current_user
      posting.site = current_site
    end
  end

end

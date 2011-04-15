class Posting::InvitationsController < ApplicationController
  
  def create
    @li_eq = params[:li_eq]
    @posting = new_posting_invitation
    if @wave = find_invitation_wave
      @wave.postings << @posting
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @li_eq = params[:li_eq]
    @wave = find_invitation_wave
    if @posting = find_invitation_posting(@wave)
      @posting.update_attributes(params[:posting_invitation])
    end
    respond_to do |format|
      format.js { render :action => 'create', :layout => false }
    end
  end
    
  private

  def find_invitation_wave
    current_user.waves(current_site).find_by_id(params[:wave_id])
  end
  
  def find_invitation_posting(wave)
    wave.postings.find_by_id(params[:id])    
  end
    
  def new_posting_invitation
    Posting::Invitation.new(params[:posting_invitation]).tap do |posting|
      posting.sponsor = current_user
      posting.site = current_site
    end
  end

end

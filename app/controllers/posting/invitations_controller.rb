class Posting::InvitationsController < ApplicationController
  
  def create
    @li_eq = params[:li_eq]
    @posting = new_posting_invitation
    @wave = current_user.waves.find_by_id(params[:wave_id])    
    if @wave && @wave.postings << @posting
      @posting.code = @posting.id
      @posting.offer!
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  private
  
  def new_posting_invitation
    Posting::Invitation.new(params[:posting_invitation]).tap do |posting|
      posting.sponsor = current_user
      posting.code = '-'
      posting.site = current_site
    end
  end

end

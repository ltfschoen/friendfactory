class Posting::InvitationsController < ApplicationController

  before_filter :require_user

  def create
    @li_eq = params[:li_eq]
    @posting = new_posting_invitation
    if @wave = current_user.find_invitation_wave_by_id(params[:wave_id])
      @wave.postings << @posting
      @posting.offer!
      InvitationsMailer.new_invitation_mail(@posting).deliver
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @li_eq = params[:li_eq]
    @wave = current_user.find_invitation_wave_by_id(params[:wave_id])
    if @wave && @posting = @wave.postings.find_by_id(params[:id])
      if @posting.update_attributes(params[:posting_invitation]) && @posting.email_changed?
        InvitationsMailer.new_invitation_mail(@posting).deliver
      end
    end
    respond_to do |format|
      format.js { render :action => 'create', :layout => false }
    end
  end

  private

  def new_posting_invitation
    Posting::Invitation.new(params[:posting_invitation]) do |posting|
      posting.sponsor = current_user
    end
  end

end

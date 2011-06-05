class Wave::ConversationsController < ApplicationController

  before_filter :require_user

  cattr_reader :per_page
  @@per_page = 12

  def index
    @inbox = current_user.inbox(current_site) || current_user.create_inbox(current_site)
    @conversation_ids = @inbox.conversation_ids.paginate(:page => params[:page], :per_page => @@per_page)
    @profiles = @inbox.recipient_profiles(current_site, @conversation_ids)
    respond_to do |format|
      format.html
    end
  end

  def show
    # Show conversation with other user identified by :profile_id
    user = Wave::Profile.find_by_id(params[:profile_id]).try(:user)
    @wave = current_user.conversation.with(user, current_site) || current_user.create_conversation_with(user, current_site)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def popup
    @popup = true
    @title = current_site.name
    @wave = current_user.conversations.site(current_site).find_by_id(params[:id])
    if @wave.present? && @wave.recipient.present?
      @title += " with #{@wave.recipient.handle(current_site)}"
    end
    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end
  
  def close    
    if inbox = current_user.inbox(current_site)
      @wave = inbox.waves.find_by_id(params[:id])
      inbox.waves.delete(@wave) if @wave.present?
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
    
end

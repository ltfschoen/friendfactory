class Wave::ConversationsController < ApplicationController

  before_filter :require_user

  helper_method :page_title

  layout 'conversation'

  def index
    @@recipient_ids = []
    @conversation_dates = []

    if @most_recent_date = params[:date]
      @most_recent_date = @most_recent_date.to_date rescue nil
    else
      @conversation_dates = current_user.inbox(current_site).
          select('date(`waves`.`updated_at`) AS updated_at, count(*) AS count').
          group('date(`waves`.`updated_at`)').
          order('date(`waves`.`updated_at`) DESC')

      @most_recent_date = @conversation_dates.shift.updated_at
    end

    respond_to do |format|
      if @most_recent_date.present? &&
          @recipient_ids = current_user.inbox(current_site).
              select('resource_id').
              where('date(`waves`.`updated_at`) = ?', @most_recent_date).
              order('`waves`.`updated_at` DESC').
              map(&:resource_id)

        @profiles_by_user_id = current_site.waves.type(Wave::Profile).
            where(:user_id => @recipient_ids).
            index_by(&:user_id)

        request.xhr? ? format.html { render :partial => 'conversations' } : format.html
      else
        render :nothing => true
      end
    end
  end

  def show
    # Conversation with other user identified by :profile_id
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
    if @wave = current_user.inbox(current_site).find_by_id(params[:id])
      @wave.unpublish!
      @wave.read
    end
    respond_to do |format|
      format.json { render :json => { :closed => true }}
    end
  end

  private

  def page_title
    "#{current_site.display_name} - #{current_profile.handle}'s Inbox"
  end

end

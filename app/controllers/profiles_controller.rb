class ProfilesController < ApplicationController

  RepublishWindow = 6.hours

  before_filter :require_user
  helper_method :page_title, :invitation_wave

  layout 'profile'

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    person = current_user.person
    if person && person.update_attributes(params[:person])
      # TODO Person should be tagged, not profile
      # TODO Move to after_create on person
      if profile = person.profile
        profile.set_tag_list_on!(current_site)
      end
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end

  def avatar
    transaction do
      @posting = Posting::Avatar.new(params[:posting_avatar]) do |avatar|
        avatar.user = current_user
        avatar.persona = current_persona
      end
      current_profile.postings << @posting
      @posting.publish!
      publish_to_home_wave(@posting)
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
      format.json { render :json => { :url => @posting.url(:polaroid), :title => current_profile.handle }, :content_type => 'text/html' }
    end
  end

  def unsubscribe
    current_user.update_attributes(params[:user])
    respond_to do |format|
      format.js { head :ok }
    end
  end

  private

  def transaction
    ActiveRecord::Base.transaction { yield }
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def publish_to_home_wave(posting)
    # TODO: Only publish a flag, not the avatar itself
    if posting
      home_wave = current_site.home_wave
      home_wave.postings.
          type(Posting::Avatar).
          published.
          where(:created_at => (Time.now - RepublishWindow)...Time.now).
          where(:user_id => posting.user[:id]).
          map(&:unpublish!)
      home_wave.postings << posting
    end
  end

  def page_title
    "#{current_site.display_name} - #{current_person.handle}'s Profile"
  end

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

end

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
    raise params.inspect
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
    @posting = new_posting_avatar
    if @posting.valid? && profile = current_user.profile(current_site)
      profile.postings << @posting
      @posting.publish!
      profile.set_active_avatar(@posting)
      home_wave = current_site.home_wave
      # TODO: Following will unpublish the avatar.
      # It should just unpublish the flag.
      home_wave.postings.
          type(Posting::Avatar).
          published.
          where(:created_at => (Time.now - RepublishWindow)...Time.now).
          where(:user_id => @posting.user[:id]).
          map(&:unpublish!)
      home_wave.postings << @posting
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

  def new_posting_avatar
    Posting::Avatar.new(params[:posting_avatar]) do |avatar|
      avatar.user = current_user
      avatar.active = true
    end
  end

  def page_title
    "#{current_site.display_name} - #{current_person.handle}'s Profile"
  end

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

end

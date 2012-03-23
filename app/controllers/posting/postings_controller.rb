class Posting::PostingsController < ApplicationController

  before_filter :require_user
  before_filter :require_authorized_user, :except => [ :fetch ]

  private

  def require_authorized_user
    unless posting.authorizes?(current_user, params[:action])
      respond_to do |format|
        format.html { redirect_to '/422.html' }
        format.any(:json, :js) { head :unprocessable_entity }
      end
    end
  end

  public

  helper_method \
      :posting,
      :page_title

  layout 'community'

  def show
    respond_to do |format|
      format.html { hash_key_param? ? send_posting : render }
    end
  end

  def edit
    respond_to do |format|
      posting_type = posting.class.name.underscore.tableize
      format.html { render :partial => File.join(posting_type, 'edit'), :object => posting }
    end
  end

  def update
    respond_to do |format|
      format.json { render :json => { :ok => posting.update_attributes(params[:posting]) }}
    end
  end

  def fetch
    respond_to do |format|
      if fetchables
        format.json { render :json => fetchables }
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  def unpublish
    respond_to do |format|
      begin
        posting.unpublish!
        format.js { render :layout => false }
      rescue
        format.js { head :unprocessable_entity }
      end
    end
  end

  private

  def posting
    @posting ||= begin
      relation = Posting::Base.published.scoped
      hash_key_param? ? relation.find_by_hash_key(params[:hash_key]) : relation.find(params[:id])
    end
  end

  def postings
    @postings ||= begin
      if params[:id].is_a?(Hash) # fetchables
        Posting::Base.published.find_all_by_id(params[:id].keys)
      end
    end
  end

  def page_title
    "#{current_site.display_name} - #{posting[:type].demodulize} Posting by #{posting.user.display_handle}"
  end

  ###

  def hash_key_param?
    params[:hash_key].present?
  end

  def send_posting
    if posting
      send_file(posting.image.path(params[:style]), :disposition => 'inline', :type => posting.image_content_type)
    end
  end

  def fetchables
    @fetchables ||= begin
      params[:id].to_a.map do |posting_id, limit|
        posting = postings.detect { |p| p[:id] == posting_id.to_i }
        comments = posting.children.includes(:user => :profile, :user => { :persona => :avatar }).type(Posting::Comment).published.order('`updated_at` DESC').limit(limit)
        comments.map! { |comment| build_fetchable(posting, comment) }.compact!
        { :id => posting_id, :comments => comments }
      end
    end
  end

  def build_fetchable(posting, comment)
    if comment.authorizes?(current_user, 'show')
      user = comment.user
      { :id         => comment.id,
        :posting_id => posting.id,
        :body       => tag_helper.truncate(comment.body, :length => 100),
        :updated_at => tag_helper.distance_of_time_in_words_to_now(comment.updated_at),
        :image_path => user.avatar.url(:thimble),
        :handle     => user.handle
      }.merge(build_fetchable_with_profile(user))
    end
  end

  def build_fetchable_with_profile(user)
    profile = user.profile
    profile.present? ? { :profile_path => url_for(profile) } : {}
  end

  def tag_helper
    TagHelper.instance
  end

  class TagHelper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::DateHelper
  end

end

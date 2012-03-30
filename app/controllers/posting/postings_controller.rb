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
      posting_id_to_limit_dictionary = params[:id]
      postings.map do |posting|
        limit = posting_id_to_limit_dictionary[posting[:id].to_s]
        comments = posting.fetchables(limit).map { |comment| build_fetchable(comment) }.compact
        { :posting_id => posting[:id], posting.fetch_type => true, :posting_comments_path => posting_comments_path(posting), :comments => comments }
      end
    end
  end

  def build_fetchable(comment)
    if comment.authorizes?(current_user, 'show')
      profile = comment.user.profile
      comment.as_json(:fetch => true).merge(profile.present? ? { :profile_path => url_for(profile) } : {})
    end
  end

end

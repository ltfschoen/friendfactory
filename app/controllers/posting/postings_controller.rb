class Posting::PostingsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user
  before_filter :require_authorized_user

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
      format.html { redirect_to '/501.html' }
      format.any(:json, :js) { head :not_implemented }
    end
  end

  def update
    respond_to do |format|
      format.json { render :json => { :ok => posting.update_attributes(params[:posting]) }}
    end
  end

  private

  def posting
    relation = Posting::Base.published.scoped
    hash_key_param? ? relation.find_by_hash_key(params[:hash_key]) : relation.find(params[:id])
  end

  def page_title
    "#{current_site.display_name} - #{posting[:type].demodulize} Posting by #{posting.user.display_handle}"
  end

  memoize :posting

  ###

  def hash_key_param?
    params[:hash_key].present?
  end

  def send_posting
    if posting
      send_file(posting.image.path(params[:style]), :disposition => 'inline', :type => posting.image_content_type)
    end
  end

  def require_authorized_user
    unless posting.authorizes?(current_user, params[:action])
      respond_to do |format|
        format.html { redirect_to '/422.html' }
        format.any(:json, :js) { head :unprocessable_entity }
      end
    end
  end

end

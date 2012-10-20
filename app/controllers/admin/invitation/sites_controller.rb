class Admin::Invitation::SitesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_admin

  helper_method \
      :site,
      :invitations,
      :invitation,
      :new_invitation,
      :page_title

  layout 'admin'

  def index
    params[:sort] ||= 'created_at'
    params[:direction] ||= 'desc'
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if new_invitation.save
        format.html { redirect_to admin_site_invitation_sites_path(site) }
      else
        format.html { render :action => 'new' }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if invitation.update_attributes(params[:invitation_site])
        format.html { redirect_to admin_site_invitation_sites_path(site) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  private

  def site
    Site.find(params[:site_id])
  end

  def invitations
    sort_fields = params[:sort].split('.').map{ |field| %Q{"#{field}"} }.join('.')
    site.invitations.
        select('"invitations".*, count("invitation_confirmations"."id") AS confirmations_count').
        type(:site).
        joins(:user => :persona).
        joins('LEFT OUTER JOIN "invitation_confirmations" ON "invitations"."id" = "invitation_confirmations"."invitation_id"').
        group('"invitations"."id"').
        order("#{sort_fields} #{params[:direction]}")
  end

  def invitation
    invitations.type(:site).find(params[:id])
  end

  def new_invitation
    ::Invitation::Site.new(params[:invitation_site]) do |invitation|
      invitation.user = current_user
    end
  end

  memoize :site, :invitations, :invitation, :new_invitation

  def page_title
    "Site Administration - Invitations"
  end

end

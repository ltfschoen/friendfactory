class FriendshipsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  after_filter :notify, :only => [ :create ]

  helper_method :personage, :inverse_friends

  def index
    respond_to do |format|
      if inverse_friends
        format.html { render 'personages/friends', :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  def create
    respond_to do |format|
      format.json { render :json => { :poked => poke }}
    end
  end

  private

  def personage
    @personage ||= begin
      Personage.enabled.site(current_site).find(params[:profile_id])
    end
  end

  def poke
    current_user.toggle_poke(personage)
  end

  memoize :poke

  def inverse_friends
    @inverse_friends ||= begin
      type = "Friendship::#{params[:type].singularize.titleize}".constantize
      personage.inverse_friends.enabled.
          where(:friendships => { :type => type }).
          includes(:persona => :avatar).
          includes(:profile).
          order('`friendships`.`created_at` DESC').
          limit(Wave::InvitationsHelper::MaximumDefaultImages)
    rescue
      nil
    end
  end

  def notify
    if poke.present?
      poke.subscriptions.notify do |subscriber|
        FriendshipsMailer.delay.create(subscriber, poke, current_site, request.host, request.port)
      end
    end
  end

end

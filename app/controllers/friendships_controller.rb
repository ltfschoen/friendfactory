class FriendshipsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

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
      if poke = current_user.toggle_poke(personage)
        deliver_friendship_email(poke)
        format.json { render :json => { :poked => true }}
      else
        format.json { render :json => { :poked => false }}
      end
    end
  end

  private

  def personage
    Personage.enabled.site(current_site).find(params[:profile_id])
  end

  def inverse_friends
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

  memoize :personage, :inverse_friends

  def deliver_friendship_email(poke)
    if mail = FriendshipsMailer.new_poke_mail(poke, current_site, request.host, request.port)
      mail.deliver
    end
  end

end

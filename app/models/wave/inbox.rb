class Wave::Inbox < Wave::Uber
  
  def conversation_ids
    waves.select('id, resource_id').order('updated_at desc')
  end
  
  def recipient_profiles(site, conversation_ids)
    Wave::Profile.site(site).includes(:active_avatars, :resource).where('waves.user_id' => recipient_user_ids(conversation_ids))
  end
  
  # def recipient_avatars(site, conversation_ids)
  #   Posting::Avatar.activated.joins(:waves => :sites).where(:user_id => recipient_user_ids(conversation_ids), :waves => { :sites => { :id => site.id }})
  # end
  
  private
  
  def recipient_user_ids(conversation_ids)
    conversation_ids.map(&:resource_id)
  end
  
end
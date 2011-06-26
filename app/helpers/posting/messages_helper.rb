module Posting::MessagesHelper
  
  def message_css_class(message, last_read_at)
    if message.sender_id == current_user.id
      'sent'
    else
      'received' + (message.created_at > last_read_at ? ' unread' : '')
    end
  end
  
end
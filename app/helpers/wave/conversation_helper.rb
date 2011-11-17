module Wave::ConversationHelper

  def link_to_unread_messages_unless_inbox
    unless [ inbox_path, wave_conversations_path ].detect{ |path| current_page?(path) }.present?
      link_to_unread_messages
    end
  end

  def link_to_unread_messages
    if current_user
      unread_conversations_count = current_user.conversations.site(current_site).chatty.unread.count
      if unread_conversations_count > 0
        content_tag(:span) { link_to(unread_conversations_count, inbox_path) }
      end
    end
  end

end
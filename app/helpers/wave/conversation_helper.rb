module Wave::ConversationHelper

  def link_to_unread_messages_unless_inbox
    unless [ inbox_path, wave_conversations_path ].detect{ |path| current_page?(path) }.present?
      link_to_unread_messages
    end
  end

  def link_to_unread_messages
    if current_user
      unread_conversations_count = current_user.inbox(current_site).unread.count
      if unread_conversations_count > 0
        content_tag(:span) { link_to(unread_conversations_count, inbox_path) }
      end
    end
  end

  def inbox_distance_of_time_in_words_to_now(datetime)
    case datetime
    when Date.today then "Today"
    when Date.yesterday then "Yesterday"
    else "#{distance_of_time_in_words_to_now(datetime)} ago".html_safe
    end
  end

  def link_to_conversations_for_date(conversation_date)
    message = "#{inbox_distance_of_time_in_words_to_now(conversation_date.updated_at)} (#{conversation_date.count}) &rarr;".html_safe
    link_to message, inbox_path(:date => conversation_date.updated_at), :remote => true, :class => 'conversations'
  end

end
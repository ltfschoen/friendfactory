module Wave::ConversationHelper

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
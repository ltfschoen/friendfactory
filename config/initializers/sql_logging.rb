if Rails.env.development?
  SqlLogging::Statistics.top_sql_queries = 5
  SqlLogging::Statistics.show_sql_backtrace = true
end

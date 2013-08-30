# module Metadata
#   class Author < Metadata::Base
#     def self.ingest ingestable
#       if personage_id = posting.user_id
#         connection.sadd "author:#{personage_id}", ingestable.id
#       end
#     end
#
#     def self.keys *personage_ids
#       personage_ids.map { |personage_id| "author:#{personage_id}" }
#     end
#   end
# end

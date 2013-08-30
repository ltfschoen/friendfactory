# module Metadata
#   class State < Metadata::Base
#     def self.ingest posting
#       if posting.published?
#         connection.sadd "state:published", posting[:id]
#       end
#     end
#   end
# end

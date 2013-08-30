# module Metadata
#   class State < Metadata::Base
#     def self.ingest posting
#       type = posting[:type].downcase.gsub /::/, ':'
#       connection.sadd "type:#{type}", posting[:id]
#     end
#   end
# end

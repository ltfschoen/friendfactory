require 'digest/sha1'

module ChatsHelper
  def chat_channel(sender, receiver)
    Digest::SHA1.hexdigest([ sender, receiver ].sort.to_s)[0..7]
  end
end
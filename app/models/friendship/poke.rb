class Friendship::Poke < Friendship::Base
  validates_presence_of :friend
end

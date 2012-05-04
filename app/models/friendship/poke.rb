class Friendship::Poke < Friendship::Base

  validates_presence_of :friend

  subscribable :poke, lambda { |poke| poke.friend }

end

class Posting::Persona < Posting::Base

  acts_as_commentable

  validates_presence_of :user

  alias_attribute :new_signup, :horizontal

end

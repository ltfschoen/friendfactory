class Posting::Persona < Posting::Base

  validates_presence_of :user

  alias_attribute :new_signup, :horizontal

end

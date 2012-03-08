class Posting::Persona < Posting::Base
  validates_presence_of :user
end

class Wave::Place < Wave::Base

  delegate :persona, :to => :user

  delegate \
      :handle,
      :location,
      :avatar,
    :to => :persona

  def technical_description
    [ super, persona.handle ].compact.join(' - ')
  end

  def subject
    persona.handle
  end

end
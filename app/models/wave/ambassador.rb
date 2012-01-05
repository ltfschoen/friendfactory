class Wave::Ambassador < Wave::Profile

  def subject
    persona.handle
  end

  def technical_description
    [ super, persona.handle ].compact * '/'
  end

  private

  def permitted_user_ids
    self[:user_id]
  end

end
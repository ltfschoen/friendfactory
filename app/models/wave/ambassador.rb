class Wave::Ambassador < Wave::Profile

  def subject
    persona.handle
  end

  def technical_description
    "Ambassador #{persona.handle}"
  end

  private

  def permitted_user_ids
    self[:user_id]
  end

end
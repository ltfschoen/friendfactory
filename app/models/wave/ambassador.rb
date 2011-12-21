class Wave::Ambassador < Wave::Profile

  def technical_description
    [ super, slug, person.handle ].compact * ' - '
  end

  private

  def permitted_user_ids
    self[:user_id]
  end

end
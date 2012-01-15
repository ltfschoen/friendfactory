class Wave::Ambassador < Wave::Profile

  def subject
    handle
  end

  private

  def permitted_user_ids
    self[:user_id]
  end

end
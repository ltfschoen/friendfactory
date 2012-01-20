class Wave::Ambassador < Wave::Profile

  def subject
    handle
  end

  def writable?(user_id)
    owner?(user_id)
  end

end
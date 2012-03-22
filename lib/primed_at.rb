module PrimedAt

  def update_primed_at
    self[:primed_at] = self[:updated_at]
    self.class.update_all({ :primed_at => self[:updated_at]}, self.class.primary_key => self[:id])
  end

  def touch(attribute = nil)
    super
    update_primed_at
  end

end
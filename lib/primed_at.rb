module PrimedAt

  def touch(attribute = nil)
    super
    update_primed_at(self[:commented_at]) if attribute.to_sym == :commented_at
  end

  def update_primed_at(datetime)
    self[:primed_at] = datetime
    self.class.update_all({ :primed_at => datetime }, self.class.primary_key => self[:id])
  end

end
module TagScrubber

  def scrub_tag(dirty_tag)
    unless dirty_tag.blank?
      tag = reduce(unpunctuate(dirty_tag.strip))
      transpose(tag) || titleize(tag)
    end
  end
  
  def unpunctuate(tag)
    tag.gsub(/,|-|_/, ' ').gsub(/[^[:alnum:][:space:]]+/, '').gsub(/\s{2,}/, ' ').strip    
  end

  def reduce(tag)
    rejects = Admin::Tag.where(['taggable_type = ? and corrected is null', self.class.name]).order('defective asc').map(&:defective)
    tag.strip.gsub(/#{rejects * '|'}/i, '').strip
  end
  
  def transpose(tag)
    Admin::Tag.where(['taggable_type = ? and corrected is not null', self.class.name]).order('corrected asc, defective asc').each do |transpose|
      result = /#{transpose.defective}/i.match(tag)
      return transpose.corrected.strip if result.present?
    end
    nil
  end
  
  def titleize(tag)
    tag.titleize if tag.present?
  end
  
end

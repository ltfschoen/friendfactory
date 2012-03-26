class Posting::Comment < Posting::Base

  attr_accessible :body

  validates_presence_of :parent_id
  validates_presence_of :body  

  belongs_to :posting,
      :class_name  => 'Posting::Base',
      :foreign_key => 'parent_id',
      :touch       => :commented_at

  def body
    self[:body] || self[:subject]
  end

end

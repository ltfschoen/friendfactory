class Posting::Comment < Posting::Base
  
  validates_presence_of :parent_id
  
  belongs_to :posting,
      :class_name => 'Posting::Base',
      :foreign_key => 'parent_id',
      :touch => true

end

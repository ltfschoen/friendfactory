class Posting::Base < ActiveRecord::Base

  set_table_name :postings

  acts_as_tree :order => 'created_at asc'
  belongs_to   :user
  belongs_to   :wave
  
  def render
    children = self.children.inject([]) do |memo, child|
      memo += child.render
    end
    children.empty? ? [ self.to_s ] : [[ self.to_s, children ]]
  end
  
  def to_s
    self[:type].to_s + ':' + self[:id].to_s
  end
  
end
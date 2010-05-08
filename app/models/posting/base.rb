class Posting::Base < ActiveRecord::Base

  set_table_name :postings

  acts_as_tree :order => 'created_at asc'
  
  has_many :children, :class_name => 'Posting::Base', :foreign_key => 'parent_id', :order => 'created_at asc' do
    def postings
      find :all, :conditions => [ "type <> 'Posting::Comment'" ], :order => 'created_at asc'
    end
    def comments
      find :all, :conditions => [ "type = 'Posting::Comment'" ], :order => 'created_at asc'
    end
  end
  
  belongs_to :user  
  belongs_to :wave,
      :class_name  => 'Wave::Base',
      :foreign_key => 'wave_id'
  
  define_index do
    indexes body
    indexes user.first_name
    indexes user.last_name
    indexes wave.topic
    indexes wave.description
    has created_at
    has updated_at
  end
  
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
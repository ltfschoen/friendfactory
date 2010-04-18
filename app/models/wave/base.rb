class Wave::Base < ActiveRecord::Base
  
  set_table_name :waves  
  has_many :postings, :class_name => 'Posting::Base', :foreign_key => 'wave_id', :conditions => 'parent_id is null'
  
  def render
    postings.inject([]) do |memo, posting|
      memo += posting.render
    end
  end
  
end

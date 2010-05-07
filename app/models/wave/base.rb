class Wave::Base < ActiveRecord::Base
  
  set_table_name :waves
  
  has_many :postings,
      :class_name  => 'Posting::Base',
      :foreign_key => 'wave_id',
      :conditions  => 'parent_id is null',
      :order       => 'created_at desc' do
    def narrow(*types)
      find :all, :conditions => [ 'type in (?)', types.map(&:to_s) ]
    end
  end
  
  belongs_to :user
  
  def render
    postings.inject([]) do |memo, posting|
      memo += posting.render
    end
  end
  
  def self.popular
    Wave::Shared.first
  end
  
end

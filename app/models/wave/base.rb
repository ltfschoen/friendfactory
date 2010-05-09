class Wave::Base < ActiveRecord::Base
  
  set_table_name :waves
  
  acts_as_slugable :source_column => :topic, :slug_column => :slug
  
  has_many :postings,
      :class_name  => 'Posting::Base',
      :foreign_key => 'wave_id',
      :conditions  => 'parent_id is null',
      :order       => 'created_at desc' do

    def for(user)
      if user.nil?
        exclude('Posting::Message')
      else
        find :all, :conditions => [ '(user_id = ?) or (receiver_id = ?)', user.id, user.id ]
      end
    end
    
    def only(*types)
      find :all, :conditions => [ 'type in (?)', types.map(&:to_s) ]
    end
    
    def exclude(*types)
      find :all, :conditions => [ 'type not in (?)', types.map(&:to_s) ]
    end    
  end
  
  belongs_to :user
  
  # def render
  #   postings.inject([]) do |memo, posting|
  #     memo += posting.render
  #   end
  # end
  
  def self.default
    Wave::Base.first
  end
  
end

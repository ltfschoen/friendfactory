class Wave::Base < ActiveRecord::Base
  
  set_table_name :waves
  
  acts_as_slugable :source_column => :topic, :slug_column => :slug

  has_and_belongs_to_many :postings,
      :class_name              => 'Posting::Base',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :conditions              => 'parent_id is null',
      :order                   => 'created_at desc' do        
    def for(user)
      if user.nil?
        exclude('Posting::Message')
      else
        where('(private = false or (private = true and ((user_id = ?) or (receiver_id = ?))))', user.id, user.id)
      end
    end
    
    def only(*types)
      where('type in (?)', types.map(&:to_s))
    end
    
    def exclude(*types)
      find :all, :conditions => [ 'type not in (?)', types.map(&:to_s) ]
    end    
  end
  
  belongs_to :user  
  belongs_to :resource, :polymorphic => true
  
  def self.default
    Wave::Base.first
  end
  
end

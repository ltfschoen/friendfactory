class Wave::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  
  set_table_name :waves

  state_machine do
    state :published
    state :unpublished
    
    event :publish do
      transitions :to => :published, :from => [ :unpublished, :published ]
    end
    
    event :unpublish do
      transitions :to => :unpublished, :from => [ :unpublished, :published ]
    end
  end
  
  belongs_to :user, :include => :user_info

  has_and_belongs_to_many :postings,
      :class_name              => 'Posting::Base',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :conditions              => 'parent_id is null',
      :order                   => 'updated_at desc' do
    def only(*types)
      where('type in (?)', types.map(&:to_s))
    end
    def exclude(*types)
      where('type not in (?)', types.map(&:to_s))
    end    
  end
  
  belongs_to :resource, :polymorphic => true
  
  def self.default
    Wave::Base.first
  end
  
end

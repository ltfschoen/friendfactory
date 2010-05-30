class Posting::Base < ActiveRecord::Base

  set_table_name :postings

  acts_as_tree :order => 'created_at asc'
  
  has_many :children,
      :class_name  => 'Posting::Base',
      :foreign_key => 'parent_id',
      :order       => 'created_at desc' do    
    def postings
      find :all, :conditions => [ "type <> 'Posting::Comment'" ], :order => 'created_at desc'
    end
    
    def comments
      find :all, :conditions => [ "type = 'Posting::Comment'" ], :order => 'created_at asc'
    end
  end
  
  belongs_to :user
  
  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :foreign_key             => 'posting_id',
      :association_foreign_key => 'wave_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc'

  validates_presence_of :user_id

  attr_readonly :user_id, :wave_id

  define_index do
    indexes body
    # TODO: Reestablish indexes on associated waves
    # indexes wave.topic,       :as => :wave_topic
    # indexes wave.description, :as => :wave_description
    indexes [ user.first_name, user.last_name], :as => :user_name
    indexes user_id
    has :created_at
    has :updated_at
    has [ :user_id, :receiver_id ], :as => :recipient_ids
    has :private, :type => :boolean
  end
    
  def to_s
    self[:type].to_s + ':' + self[:id].to_s
  end

end

class Wave::Conversation < Wave::Base

  has_and_belongs_to_many :messages,
      :class_name              => 'Posting::Message',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :conditions              => 'parent_id is null',
      :order                   => 'created_at asc'

  alias :recipient :resource

end
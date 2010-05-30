class Wave::Profile < Wave::Base
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc' do
    def active
      find :first, :conditions => [ 'active = true' ]
    end
  end

  def avatar
    self.avatars.active
  end
  
end

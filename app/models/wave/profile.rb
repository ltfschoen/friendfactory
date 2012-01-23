class Wave::Profile < Wave::Base

  RepublishWindow = 6.hours

  delegate \
      :handle,
      :first_name,
      :last_name,
      :age,
      :dob,
      :location,
    :to => :user

  has_many :photos,
      :through     => :publications,
      :source      => :resource,
      :source_type => 'Posting::Base',
      :conditions  => { :postings => { :state => :published, :type => 'Posting::Photo' }},
      :order       => '`postings`.`created_at` DESC'

  def writable?(user_id)
    owner?(user_id)
  end

  def touch(avatar = nil)
    super()
  end

  def publish_posting_to_waves(posting)
    if site = posting.site
      related_postings(posting).map(&:unpublish!)
      site.home_wave
    end
  end

  def related_postings(posting)
    posting.site.home_wave.postings.
        type(Posting::Avatar).
        published.
        where(:created_at => (Time.now - RepublishWindow)...Time.now).
        where(:user_id => posting.user[:id]).
        where('`postings`.`id` <> ?', posting.id)
  end

end

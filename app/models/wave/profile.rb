require 'tag_scrubber'

class Wave::Profile < Wave::Base

  include TagScrubber

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

  def tag_list
    current_site.present? ? tag_list_on(current_site) : []
  end

  # TODO Implement
  def set_tag_list_on(site)
    # if resource.present?
    #   signal_ids = site.signal_categories.map { |category| resource.send(:"#{category.name}_id") }.compact
    #   signal_display_names = Signal::Base.find_all_by_id(signal_ids).map(&:display_name)
    #   tag_list = [ signal_display_names, scrub_tag(resource.location) ].flatten.compact.join(',')
    #   super(site, tag_list)
    # end
  end

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

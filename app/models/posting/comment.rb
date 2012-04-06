class Posting::Comment < Posting::Base

  attr_accessible :body

  validates_presence_of :parent_id
  validates_presence_of :body  

  belongs_to :posting,
      :class_name  => 'Posting::Base',
      :foreign_key => 'parent_id',
      :touch       => :commented_at

  def body
    self[:body] || self[:subject]
  end

  def as_json(*args)
    opts = args.extract_options!
    if opts.delete(:fetch)
      fetch_as_json
    else
      super(options)
    end
  end

  private

  def fetch_as_json
    { :id         => id,
      :body       => tag_helper.truncate(body, :length => 100),
      :updated_at => tag_helper.distance_of_time_in_words_to_now(created_at),
      :image_path => user.avatar.url(:thimble),
      :handle     => user.handle }
  end

  def tag_helper
    TagHelper.instance
  end

  class TagHelper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::DateHelper
  end

end

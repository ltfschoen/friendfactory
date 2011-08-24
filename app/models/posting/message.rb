class Posting::Message < Posting::Base

  attr_accessor :receiver
  attr_accessor :site

  alias_attribute :sender, :user
  alias_attribute :sender_id, :user_id

  attr_accessible :subject, :body
  attr_readonly :user

  validates_presence_of :user, :receiver, :site
  
  has_many :notifications
  
  after_create do |posting|
    if (posting.receiver.id != posting.sender_id) && (wave = posting.receiver.conversation_with(posting.sender, posting.site))
      wave.messages << posting
    end
  end

  def receiver
    @receiver || waves.where('`waves`.`user_id` <> ?', user_id).limit(1).first.try(:user)
  end

end

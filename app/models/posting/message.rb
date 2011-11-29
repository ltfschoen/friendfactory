class Posting::Message < Posting::Base

  attr_accessor :site
  attr_writer   :receiver

  alias_attribute :sender, :user
  alias_attribute :sender_id, :user_id

  attr_accessible :subject, :body

  validates_presence_of :user
  validates_presence_of :receiver, :site, :on => :create

  def receiver
    @receiver ||= waves.where('`waves`.`user_id` <> ?', user_id).limit(1).first.try(:user)
  end

  def receiver_id
    @receiver.id
  end

end

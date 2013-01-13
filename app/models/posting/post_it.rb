require 'primed_at'

class Posting::PostIt < Posting::Base
  include PrimedAt
  attr_accessible :subject
  validates_presence_of :subject, :user_id
  subscribable :comment, :user
  after_commit :create_metadata

protected

  def metadata_klasses
    [ "Metadata::Author", "Metadata::Feed", "Metadata::State", "Metadata::Type" ]
  end

  def create_metadata
    metadata_klasses.each do |metadata_klass|
      metadata_klass.safe_constantize.ingest self
    end
  end
end

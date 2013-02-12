require 'primed_at'

class Posting::PostIt < Posting::Base
  include PrimedAt

  attr_accessible :subject

  validates_presence_of :subject, :user_id

  subscribable :comment, :user

  after_commit :create_metadata

  def metadata_klasses
    # [ Metadata::Author, Metadata::Feed, Metadata::State, Metadata::Type ]
    [ Metadata::Feed ]
  end

  def create_metadata
    metadata_klasses.each do |metadata_klass|
      metadata_klass.ingest self
    end
  end
end

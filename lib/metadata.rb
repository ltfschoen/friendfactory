module Metadata

  DEFAULT_METADATA_KLASSES = [ Metadata::Author, Metadata::Feed, Metadata::State ]

  def included base
    base.extend ClassMethods
  end

  module ClassMethods
    after_commit :create_metadata
  end

protected

  def metadata_klasses
    DEFAULT_METADATA_KLASSES
  end

  def create_metadata
    metadata_klasses.each do |metadata_klass|
      metadata_klass = metadata_klass.safe_constantize if metadata_klass.is_a? String
      metadata_klass.ingest self
    end
  end

end

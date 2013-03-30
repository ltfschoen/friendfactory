module Metadata
  module Ingestable
    extend ActiveSupport::Concern

    included do
      after_commit :ingest
      @_metadata ||= []
    end

    def ingest
      self.class.metadata.map do |class_name|
        class_name = "posting/metadata/#{class_name}".camelize
        if klass = class_name.safe_constantize
          klass.ingest self
          class_name
        end
      end
    end

    def ingestable?
      true
    end

    module ClassMethods
      def inherited klass
        klass.has_metadata *@_metadata
      end

      def has_metadata *klasses
        @_metadata ||= []
        @_metadata += klasses
        @_metadata = @_metadata.flatten.compact.uniq
      end

      def metadata
        @_metadata
      end
    end
  end
end

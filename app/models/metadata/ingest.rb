require "active_support/concern"

module Metadata
  module Ingest
    extend ActiveSupport::Concern

    included do
      after_commit :ingest if respond_to? :after_commit
      @_metadata ||= []
    end

    module ClassMethods
      def inherited klass
        super
        klass.ingest *@_metadata
      end

      def ingest *klasses
        @_metadata ||= []
        @_metadata += klasses
        @_metadata = @_metadata.flatten.compact.uniq
      end

      def metadata
        @_metadata
      end
    end

    def ingest
      return false unless published?
      self.class.metadata.select do |class_name|
        if klass = (metadata_class class_name)
          klass.ingest self
          class_name
        else
          warn_uningestable class_name
          nil
        end
      end
    end

    def ingestable?
      true
    end

    def metadata
      self.class.metadata
    end

    def warn_uningestable klass
      Rails.logger.warn "Metadata::Ingest #{klass} does not allow ingest"
    end

    def metadata_class class_name
      klass = "metadata/#{class_name.to_s}".camelize.safe_constantize
      klass.respond_to?(:ingest) and klass
    end
  end
end

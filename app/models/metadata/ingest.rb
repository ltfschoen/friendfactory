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
        klass.ingest *@_metadata
      end

      def ingest *klasses
        @_metadata ||= []
        # klasses.map! do |klass|
        #   defined? klass ? klass : (Rails.logger.warn "Metadata::Ingest unknown metadata class #{klass}")
        # end
        @_metadata += klasses
        @_metadata = @_metadata.flatten.compact.uniq
      end

      def metadata
        @_metadata
      end
    end

    def ingest
      self.class.metadata.map do |klass|
        if klass.respond_to? :ingest
          klass.ingest self
        else
          Rails.logger.warn "Metadata::Ingest #{klass} does not allow ingest"
        end
      end
    end

    def ingestable?
      true
    end
  end
end

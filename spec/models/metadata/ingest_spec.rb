require "spec_helper"

describe Metadata::Ingest do
  describe "included" do
    context "without after_commit" do
      let(:klass) { Class.new }
      it "should not raise" do
        expect { klass.send :include, Metadata::Ingest }.to_not raise_error
      end
    end

    context "with after_commit" do
      let(:klass) { Class.new }
      it "should call after_commit" do
        klass.should_receive(:after_commit).with(:ingest)
        klass.send :include, Metadata::Ingest
      end
    end
  end

  describe "class" do
    let(:klass) { Class.new { include Metadata::Ingest }}
    let(:metadata_klasses) {[ "Wave", "Author", "CreatedAt" ]}
    before { klass.ingest *metadata_klasses }
    subject { klass }

    it { should respond_to :ingest }
    it { should respond_to :metadata}
    its(:metadata) { should =~ metadata_klasses}

    it "should inherit metadata" do
      subclass = Class.new klass
      subclass.metadata.should =~ metadata_klasses
    end

    it "should concat and compact metadata" do
      metadata_klass = "MetadataKlass"
      subject.ingest metadata_klass
      subject.ingest nil
      subject.metadata.should =~ (metadata_klasses << metadata_klass)
    end

    it "should have compact and unique metadata" do
      metadata_klass = "MetadataKlass"
      subject.ingest metadata_klass, metadata_klass, metadata_klass
      subject.metadata.should =~ (metadata_klasses << metadata_klass)
    end
  end

  describe "instance" do
    let(:klass) { Class.new { include Metadata::Ingest }}
    subject { klass.new }

    it { should respond_to :ingest }
    it { should respond_to :ingestable? }
    its(:ingestable?) { should be_true }

    describe "#ingest" do
      let(:metadata) { double }
      before { klass.ingest metadata }

      it "should metadata#ingest" do
        metadata.should_receive(:ingest).with(subject)
        subject.ingest
      end

      it "should warn for invalid metadata" do
        Rails.logger.should_receive(:warn)
        subject.ingest
      end
    end
  end
end

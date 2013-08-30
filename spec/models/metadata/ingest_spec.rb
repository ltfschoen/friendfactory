require "spec_helper"

describe Metadata::Ingest do
  describe "included" do
    context "without after_commit" do
      let(:klass) { Class.new }
      it "should not raise" do
        expect { klass.send :include, Metadata::Ingest }.to_not raise_error
      end
    end

    context "after_commit" do
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
    its(:metadata) { should =~ metadata_klasses }

    it "should inherit metadata" do
      subclass = Class.new klass
      expect(subclass.metadata).to eq metadata_klasses
    end

    it "should concat and compact metadata" do
      metadata_klass = "MetadataKlass"
      subject.ingest metadata_klass
      subject.ingest nil
      expect(subject.metadata).to eq (metadata_klasses << metadata_klass)
    end

    it "should have compact and unique metadata" do
      metadata_klass = "MetadataKlass"
      subject.ingest metadata_klass, metadata_klass, metadata_klass
      expect(subject.metadata).to eq (metadata_klasses << metadata_klass)
    end
  end

  describe "instance" do
    let(:klass) { Class.new { include Metadata::Ingest; def published?; true; end }}

    subject { klass.new }

    it { should respond_to :ingest }
    it { should respond_to :ingestable? }
    it { should respond_to :warn_uningestable }
    it { should respond_to :published? }
    its(:ingestable?) { should be_true }

    describe "#metadata" do
      let(:metadata) { :wave }
      before { klass.ingest metadata }
      its(:metadata) { should eq klass.metadata }
    end

    describe "#metadata_class" do
      context "with valid class_name" do
        let(:class_name) { :wave }
        subject { klass.new.metadata_class class_name }
        it { should eq Metadata::Wave }
      end

      context "with invalid class_name" do
        let(:class_name) { :dummy }
        subject { klass.new.metadata_class class_name }
        it { should be_false }
      end
    end

    describe "#ingest" do
      context "published" do
        context "with valid metadata" do
          let(:metadata) { :wave }
          before { klass.ingest metadata }

          it "calls ingest on metadata class" do
            Metadata::Wave.should_receive(:ingest).with(subject)
            subject.ingest
          end

          its(:ingest) { should eq [ metadata ]}
        end

        context "with invalid metadata" do
          let(:metadata) { :wave }
          before { klass.ingest metadata }

          it "should warn" do
            Rails.logger.should_receive(:warn)
            subject.ingest
          end
        end

        context "with no metadata" do
          its(:ingest) { should be_empty }
        end
      end

      context "unpublished" do
        before { def subject.published?; false; end }
        its(:ingest) { should be_false }
      end
    end
  end
end

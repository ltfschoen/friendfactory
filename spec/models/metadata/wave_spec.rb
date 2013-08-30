require "spec_helper"

describe Metadata::Wave::InvalidWaveIdError do
  it { should be_a Exception }
end

describe Metadata::Wave do
  before { Redis.current.flushall }

  describe "class" do
    subject { described_class }

    it { should respond_to :ingest }

    context "valid ingestable" do
      let(:wave_id) { 100 }
      let(:ingestable_id) { 200 }
      let(:ingestable) { double id: ingestable_id, wave_id: wave_id }
      subject { described_class.ingest ingestable }

      it { should be_an_instance_of Metadata::Wave }
      its(:postings) { should include ingestable.id }
    end

    context "invalid ingestable" do
      let(:uningestable) { Class.new }

      it "should warn when no wave_id attribute" do
        described_class.should_receive(:warn).with(uningestable, "missing attribute wave_id")
        subject.ingest uningestable
      end

      it "should warn when wave_id is nil" do
        uningestable.stub(:wave_id).and_return(nil)
        described_class.should_receive(:warn).with(uningestable, "invalid wave_id")
        subject.ingest uningestable
      end
    end
  end

  describe "instance" do
    let(:wave_id) { 666 }
    subject { Metadata::Wave.new wave_id }

    it { should be_an_instance_of Metadata::Wave }
    it { should be_a Metadata::Base }
    it { should respond_to :id }
    it { should respond_to :postings }
    its(:id) { should eq wave_id }
    it "requires a non-nil id" do
      expect { Metadata::Wave.new nil }.to raise_error Metadata::Wave::InvalidWaveIdError
    end
  end
end

require "spec_helper"

describe Metadata::Base do
  describe "class" do
    subject { described_class }
    it { should respond_to :connection }
    it { should respond_to :warn }
    its(:included_modules) { should include Redis::Objects }
    its(:connection) { should be_an_instance_of Redis }
    it "logs warnings" do
      ingestable = Object.new
      ingestable.stub_chain(:class, :name).and_return("Posting::Base")
      Rails.logger.should_receive(:warn).with("Metadata::Base Posting::Base no id")
      subject.warn ingestable, "no id"
    end
  end
end

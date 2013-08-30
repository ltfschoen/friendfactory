require 'spec_helper'

describe Posting::Base do
  it { should be_an_instance_of Posting::Base }
  it { should be_a ActiveRecord::Base }

  describe "class" do
    subject { described_class }
    # it { should respond_to :ingest }
    its(:included_modules) { should include ActiveRecord::Transitions }
    its(:included_modules) { should include Subscribable }
    # its(:metadata) { should include :wave }
  end

  describe "instance" do
    subject { Posting::Base.new }
  end
end

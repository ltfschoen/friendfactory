require "spec_helper"

describe Metadata::Base do
  describe "class" do
    subject { described_class }

    before :each do
      @rediscloud_url = ENV["REDISCLOUD_URL"]
      @database = ENV["REDIS_DATABASE"]
      ENV["REDISCLOUD_URL"] = nil
      ENV["REDIS_DATABASE"] = nil
    end

    after :each do
      ENV["REDISCLOUD_URL"] = @rediscloud_url
      ENV["REDIS_DATABASE"] = @database
    end

    it { should respond_to :connection }
    it "caches the connection" do
      subject.connection.should be subject.connection
    end

    describe "::connection" do
      subject { connection }
      let(:connection) { described_class.connection reload: true }

      it { should be_an_instance_of Redis }
      describe "default connection" do
        subject { connection.client }
        its(:host) { should eq "localhost"}
        its(:port) { should eq 6379 }
        its(:scheme) { should eq "redis" }
      end

      describe "ENV['REDISCLOUD_URL']" do
        before { ENV["REDISCLOUD_URL"] = "http://127.0.0.1:6379" }
        subject { connection.client }
        its(:host) { should eq "127.0.0.1"}
        its(:port) { should eq 6379 }
        its(:scheme) { should eq "redis" }
      end
    end
  end
end

require "spec_helper"

describe Posting::Video do
  let(:valid_attrs) {{ url: "http://youtube.com/watch?v=lzRKEv6cHuk" }}
  # let(:video) { Posting::Video.new(valid_attrs).tap { |video| video.user = mock_model(Personage) }}
  let(:video) { Posting::Video.new(valid_attrs) }

  describe "valid" do
    it "has valid attributes" do
      pending
      video.should be_valid
    end

    it "has youtu.be url" do
      pending
      video.url = 'http://youtu.be/lzRKEv6cHuk'
      video.should be_valid
    end
  end

  describe "invalid" do
    it "has no url" do
      pending
      video.url = nil
      video.should_not be_valid
    end

    it "has no user" do
      pending
      video.user = nil
      video.should_not be_valid
    end

    it "has malformed youtube url" do
      pending
      video.url = 'http://youtube.com/v=123'
      video.should_not be_valid
    end

    it "has malformed youtu.be url" do
      pending
      video.url = 'http://youtu.be/v=123'
      video.should_not be_valid
    end
  end

  describe "bulk update" do
    it "doesn't allow user" do
      pending
      video = Posting::Video.new(valid_attrs.merge(:user => mock_model(User)))
      video.user.should be_nil
    end
  end

  describe "vid" do
    it "youtube url" do
      pending
      video.vid.should == 'lzRKEv6cHuk'
    end

    it "youtu.be url" do
      pending
      video.url = 'http://youtu.be/lzRKEv6cHuk'
      video.vid.should == 'lzRKEv6cHuk'
    end
  end

end

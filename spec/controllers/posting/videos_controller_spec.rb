require 'spec_helper'

describe Posting::VideosController do

  # fixtures :users, :sites, :waves, :sites_waves
  # set_fixture_class :waves => 'Wave::Base', :postings => 'Posting::Base'

  # let(:wave) { waves(:friskyhands_community_wave) }
  let(:video_url) { "http://youtu.be/lzRKEv6cHuk" }

  before(:each) do
    # login :friskyhands, :adam
  end

  describe 'assigns' do
    before(:each) do
      # xhr :post, :create, { :wave_id => wave.id, :posting_video => { :url => video_url } }
    end

    it "a new video posting to @posting" do
      pending
      assigns[:posting].should be_an_instance_of(Posting::Video)
    end

    it 'publishes the new posting' do
      pending
      assigns[:posting].state.should == 'published'
    end

    it "param url to the video url" do
      pending
      assigns[:posting].url.should == video_url
    end

    it "current user to user" do
      pending
      assigns[:posting].user.should == users(:adam)
    end

    it "community wave to @wave" do
      pending
      assigns[:wave].should == wave
    end

    it 'the new video postings to the wave' do
      pending
      expect {
        xhr :post, :create, { :wave_id => wave.id, :posting_video => { :url => video_url } }
      }.to change{ wave.postings(true).length }.by(1)
    end
  end

end

require 'spec_helper'

describe Posting::VideosController do
  
  fixtures :users, :sites, :waves, :sites_waves

  set_fixture_class :waves => 'Wave::Base'
  
  before(:each) do
    current_site(sites(:friskyhands))
    current_user(users(:adam))
  end
  
  let(:video_url) { "http://youtu.be/lzRKEv6cHuk" }

  describe 'assign' do
    before(:each) do
      xhr :post, :create, { :wave_id => mock_model(Wave::Base).id, :posting_video => { :url => video_url } }
    end

    it "a new video posting to @posting" do
      assigns[:posting].should be_an_instance_of(Posting::Video)
    end
  
    it "param url to the video url" do
      assigns[:posting].url.should == video_url
    end
    
    it "current user to user" do
      assigns[:posting].user.should == users(:adam)
    end
  end
    
end

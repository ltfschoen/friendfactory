require 'spec_helper'

describe Posting::PhotosController do
  describe "routing" do
    it "recognizes #create" do
      pending
      { :post => "waves/42/postings/photos" }.should route_to(:controller => 'posting/photos', :action => 'create', :wave_id => '42')
    end
   
    it 'recognizes wave_postings_photos_path' do
      pending
      wave_postings_photos_path('42').should == '/waves/42/postings/photos'
    end
  end
end

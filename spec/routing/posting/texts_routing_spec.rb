require 'spec_helper'

describe Posting::TextsController do
  describe "routing" do
    it "recognizes #create" do
      pending
      { :post => "waves/42/postings/texts" }.should route_to(:controller => 'posting/texts', :action => 'create', :wave_id => '42')
    end
   
    it 'recognizes wave_postings_texts_path' do
      pending
      wave_postings_texts_path('42').should == '/waves/42/postings/texts'
    end
  end
end

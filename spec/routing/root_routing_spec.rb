require 'spec_helper'

describe ApplicationController do
  describe 'routing' do
    it 'recognizes get /' do
      pending
      { :get => '/' }.should route_to(:controller => 'waves/base', :action => 'show')
    end
    
    it "doesn't recognize post /" do
      { :post => '/' }.should_not be_routable
    end

    it "doesn't recognize put /" do
      { :put => '/' }.should_not be_routable
    end

    it "doesn't recognize delete /" do
      { :delete => '/' }.should_not be_routable
    end
  end
end
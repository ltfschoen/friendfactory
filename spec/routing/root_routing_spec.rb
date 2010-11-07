require 'spec_helper'

describe ApplicationController do
  describe 'routing' do
    it 'recognizes /' do
      { :get => '/' }.should route_to(:controller => 'waves', :action => 'show')
    end
  end
end
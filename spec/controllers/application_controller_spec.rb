require 'spec_helper'

describe WelcomeController do

  fixtures :sites
  
  describe 'current_site' do    
    let(:site) { sites(:friskyhands) }
    
    it 'should support production urls' do
      request.stub(:host => "#{site.name}.com")
      controller.send(:current_site).should == site
    end
    
    it 'should support development urls' do
      request.stub(:host => "#{site.name}.localhost:3000")
      controller.send(:current_site).should == site
    end

    it 'should support staging urls' do
      request.stub(:host => "staging.#{site.name}.com")
      controller.send(:current_site).should == site
    end
    
    it 'should not find a site' do
      request.stub(:host => "crap.com")
      controller.send(:current_site).should_not == site
    end
  end

end
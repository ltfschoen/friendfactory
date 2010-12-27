require 'spec_helper'

describe Wave::ConversationsController do
  describe 'routing' do
    it 'recognizes #popup' do
      { :get => '/wave/conversations/666/popup' }.should route_to(:controller => 'wave/conversations', :action => 'popup', :id => '666')
    end

    it 'recognizes popup_wave_conversation_path' do
      popup_wave_conversation_path('666').should == '/wave/conversations/666/popup'
    end
  end
end

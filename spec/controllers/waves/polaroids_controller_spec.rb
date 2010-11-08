require 'spec_helper'

describe Waves::PolaroidsController do

  def mock_wave(stubs={})
    (@mock_wave ||= mock_model(Wave::Polaroid).as_null_object).tap do |wave|
      wave.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns polaroid dynamic wave to @wave" do
      posting = Factory.build(:avatar)
      wave = double('polaroid_wave')
      Struct::PolaroidWave.should_receive(:new).and_return(wave)
      get :index, {}, { :lurker => true }
      assigns(:wave).should eq(wave)
    end    
  end

end

class Posting::WaveProxy < Posting::Base
  after_save do |proxy|
    proxy.resource.save
  end
end
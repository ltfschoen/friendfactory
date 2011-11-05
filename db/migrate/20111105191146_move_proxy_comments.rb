class MoveProxyComments < ActiveRecord::Migration
  def self.up
    Posting::WaveProxy.all.each do |proxy|
      if wave = proxy.resource
        if posting = wave.postings.first
          posting.children << proxy.children
        end
      end
    end
  end

  def self.down
  end
end

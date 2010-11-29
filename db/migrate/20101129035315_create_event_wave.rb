class CreateEventWave < ActiveRecord::Migration
  def self.up
    require File.join(Rails.root, 'db', 'seeds')
  end

  def self.down
  end
end

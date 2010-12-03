class CreateCommunityWave < ActiveRecord::Migration
  def self.up
    Wave::Base.update_all('type = "Wave::Community"', 'type = "Wave::Shared"')
  end

  def self.down
    Wave::Base.update_all('type = "Wave::Shared"', 'type = "Wave::Community"')
  end
end

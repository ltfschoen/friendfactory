class CreateUberWaves < ActiveRecord::Migration
  def self.up
    create_table :uber_waves, :id => false, :force => true do |t|
      t.integer   :uber_wave_id
      t.integer   :wave_id
    end
    add_index :uber_waves, [ :uber_wave_id, :wave_id ]
    add_index :uber_waves, :wave_id
  end

  def self.down
    drop_table :uber_waves
  end
end

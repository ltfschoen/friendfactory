class CreatePostingsWaves < ActiveRecord::Migration
  def self.up
    create_table :postings_waves, :id => false do |t|
      t.integer :posting_id
      t.integer :wave_id
    end
    add_index :postings_waves, [ :posting_id, :wave_id ]
    add_index :postings_waves, [ :wave_id ]
  end

  def self.down
    drop_table :postings_waves rescue nil
  end
end

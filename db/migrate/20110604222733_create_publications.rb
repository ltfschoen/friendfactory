class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications, :force => true do |t|
      t.integer   :wave_id, :null => false
      t.integer   :resource_id, :null => false
      t.string    :resource_type, :null => false
      t.timestamps
    end
    add_index :publications, [ :wave_id, :resource_id ]
    add_index :publications, [ :resource_id ]
    say 'migrating postings_waves to publications'
    ActiveRecord::Base.connection.select_all('select posting_id, wave_id from postings_waves').each do |posting_wave|
      ::Publication.create!(:wave_id => posting_wave['wave_id'], :resource_id => posting_wave['posting_id'], :resource_type => 'Posting::Base')
    end
    rename_table :postings_waves, :postings_waves_as_habtm
  end

  def self.down
    rename_name :postings_waves_as_habtm, :postings_waves
    drop_table :publications
  end
end

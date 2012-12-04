class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications, :force => true do |t|
      t.integer   :wave_id, :null => false
      t.integer   :resource_id, :null => false
      t.string    :resource_type, :null => false
      t.timestamps :null => true
    end
    add_index :publications, [ :wave_id, :resource_id, :resource_type ]
    add_index :publications, [ :resource_id, :resource_type ]

    say 'migrating postings_waves to publications'
    # ActiveRecord::Base.connection.select_all('select posting_id, wave_id from postings_waves').each do |posting_wave|
    #   ::Publication.create!(:wave_id => posting_wave['wave_id'], :resource_id => posting_wave['posting_id'], :resource_type => 'Posting::Base')
    # end

    # drop_table :postings_waves_as_habtm rescue nil
    drop_table :postings_waves rescue nil
    # rename_table :postings_waves, :postings_waves_as_habtm

    # say "Drop table postings_waves_as_habtm"
    # say "drop_table :postings_waves_as_habtm", true
  end

  def self.down
    # rename_table :postings_waves_as_habtm, :postings_waves
    create_table :postings_waves, :id => false do |t|
      t.integer :posting_id
      t.integer :wave_id
    end

    drop_table :publications
  end
end

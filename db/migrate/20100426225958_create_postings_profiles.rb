class CreatePostingsProfiles < ActiveRecord::Migration
  def self.up
    create_table :postings_profiles, :id => false do |t|
      t.integer :posting_id
      t.integer :profile_id
    end
    add_index :postings_profiles, [ :posting_id, :profile_id ]
    add_index :postings_profiles, [ :profile_id ]
  end

  def self.down
    drop_table :postings_profiles rescue nil
  end
end

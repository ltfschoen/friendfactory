class CreateInvitations < ActiveRecord::Migration
  def self.up    
    create_table :invitations, :force => true do |t|
      t.integer     :event_id
      t.integer     :profile_id
      t.integer     :attendance
      t.timestamps
    end
    add_index :invitations, [ :event_id, :profile_id ]
    add_index :invitations, :profile_id    
  end

  def self.down
    drop_table :invitations rescue nil
  end
end

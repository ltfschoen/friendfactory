class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations, :force => true do |t|
      t.string    :code,       :null => false
      t.integer   :site_id,    :null => false
      t.integer   :sponsor_id, :null => false
      t.string    :email
      t.timestamps
    end

    add_index :invitations, [ :email, :code, :site_id ]
  end

  def self.down
    drop_table :invitations rescue nil
  end
end

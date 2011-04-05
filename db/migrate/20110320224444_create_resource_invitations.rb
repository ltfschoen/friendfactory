class CreateResourceInvitations < ActiveRecord::Migration
  def self.up
    create_table :resource_invitations, :force => true do |t|
      t.datetime  :expires_at
    end
  end

  def self.down
    drop_table :resource_invitations rescue nil
  end
end

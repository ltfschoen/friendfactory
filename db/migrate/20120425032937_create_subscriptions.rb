class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions, :force => true do |t|
      t.integer   :user_id,       :null => false
      t.integer   :resource_id,   :null => false
      t.string    :resource_type, :nuil => false
      t.string    :type,          :null => false
      t.string    :state
      t.datetime  :notified_at
      t.timestamps :null => true
    end
    add_index :subscriptions,
      [ :user_id, :resource_id, :resource_type ],
      name: 'index_subscriptions_on_user_id_resource_id_resource_type',
      unique: true
  end

  def self.down
    drop_table :subscriptions rescue nil
  end
end

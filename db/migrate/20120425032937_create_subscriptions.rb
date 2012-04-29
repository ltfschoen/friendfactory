class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions, :force => true do |t|
      t.integer   :user_id,    :null => false
      t.integer   :posting_id, :null => false
      t.string    :type,       :null => false
      t.string    :state
      t.datetime  :notified_at
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions rescue nil
  end
end

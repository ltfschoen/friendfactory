class CreateResourceEvents < ActiveRecord::Migration
  def self.up
    create_table :resource_events, :force => true do |t|
      t.datetime    :start_date
      t.datetime    :end_date
      t.boolean     :private
      t.boolean     :rsvp
    end
  end

  def self.down
    drop_table :resource_events rescue nil
  end
end

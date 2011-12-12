class AddPaneToDomainValues < ActiveRecord::Migration
  def self.up
    add_column :signal_categories_signals, :pane, :integer
  end

  def self.down
    remove_column :signal_categories_signals, :pane
  end
end

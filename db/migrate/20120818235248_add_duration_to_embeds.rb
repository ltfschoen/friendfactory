class AddDurationToEmbeds < ActiveRecord::Migration
  def self.up
    add_column :resource_embeds, :duration, :float
  end

  def self.down
    remove_column :resource_embeds, :duration
  end
end

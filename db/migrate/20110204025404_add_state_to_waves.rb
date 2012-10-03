class AddStateToWaves < ActiveRecord::Migration
  def self.up
    add_column :waves, :state, :string
    # Wave::Base.update_all(:state => :published)
  end

  def self.down
    remove_column :waves, :state rescue nil
  end
end

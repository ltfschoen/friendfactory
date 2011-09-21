class AddMailerToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :mailer, :string
  end

  def self.down
    remove_column :sites, :mailer
  end
end

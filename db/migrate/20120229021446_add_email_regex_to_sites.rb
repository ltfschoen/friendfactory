class AddEmailRegexToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :email_domain_regex,        :string
    add_column :sites, :email_domain_display_name, :string
  end

  def self.down
    remove_column :sites, :email_domain_regex
    remove_column :sites, :email_domain_display_name
  end
end

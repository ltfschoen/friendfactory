class CreateStylesheets < ActiveRecord::Migration
  def self.up
    create_table :stylesheets, :force => true do |t|
      t.integer :site_id, :null => false
      t.string  :controller_name
      t.text    :css
      t.timestamps
    end
    Site.all.each { |site| site.stylesheets.create(:css => site.css) }
    remove_column :sites, :css
    add_index :stylesheets, [ :site_id, :controller_name ]
  end

  def self.down
    add_column :sites, :css, :text
    Site.all.each { |site| site.update_attribute(:css, site.stylesheets.map(&:css).join) }
    drop_table :stylesheets
  end
end

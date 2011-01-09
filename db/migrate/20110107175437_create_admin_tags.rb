class CreateAdminTags < ActiveRecord::Migration
  def self.up
    create_table :admin_tags, :force => true do |t|
      t.string :taggable_type
      t.string :defective, :null => false
      t.string :corrected
    end
  end

  def self.down
    drop_table :admin_tags rescue nil
  end
end

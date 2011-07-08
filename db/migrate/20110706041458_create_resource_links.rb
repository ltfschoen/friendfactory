class CreateResourceLinks < ActiveRecord::Migration
  def self.up
    create_table :resource_links, :force => true do |t|
      t.integer :posting_id
      t.text    :original_url
      t.text    :url
      t.string  :type
      t.integer :cache_age
      t.boolean :safe
      t.string  :safe_type
      t.text    :safe_message
      t.string  :provider_name
      t.string  :provider_url
      t.string  :provider_display
      t.text    :favicon_url
      t.text    :title
      t.text    :description
      t.text    :author_name
      t.text    :author_url      
      t.text    :content
      t.integer :location_id
    end
    
    create_table :resource_embeds, :force => true do |t|
      t.integer :resource_link_id
      t.string  :type
      t.boolean :primary, :default => false
      t.text    :body
      t.integer :width
      t.integer :height      
    end
  end

  def self.down
    drop_table :resource_links rescue nil
    drop_table :resource_embeds rescue nil    
  end
end

class CreatePostingAvatars < ActiveRecord::Migration
  def self.up
    add_column :postings, :active,             :boolean
    add_column :postings, :image_file_name,    :string
    add_column :postings, :image_content_type, :string
    add_column :postings, :image_file_size,    :integer
    add_column :postings, :image_updated_at,   :datetime
  end

  def self.down
    remove_column :postings, :active rescue nil
    remove_column :postings, :image_file_name rescue nil
    remove_column :postings, :image_content_type rescue nil
    remove_column :postings, :image_file_size rescue nil
    remove_column :postings, :image_updated_at rescue nil
  end
end

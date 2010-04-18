class CreateMessagePostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :receiver_id,         :integer
    add_column :postings, :subject,             :text
    add_column :postings, :read_at,             :datetime
    add_column :postings, :sender_deleted_at,   :datetime
    add_column :postings, :receiver_deleted_at, :datetime
    
    add_index  :postings, :receiver_id
  end

  def self.down
    remove_column :postings, :receiver_id         rescue nil
    remove_column :postings, :subject             rescue nil
    remove_column :postings, :body                rescue nil
    remove_column :postings, :read_at             rescue nil
    remove_column :postings, :sender_deleted_at   rescue nil
    remove_column :postings, :receiver_deleted_at rescue nil
  end
end
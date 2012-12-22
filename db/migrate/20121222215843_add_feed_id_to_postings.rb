class AddFeedIdToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :feed_id, :integer
  end
end

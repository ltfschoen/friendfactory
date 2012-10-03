class AddPrimedAtToPostings < ActiveRecord::Migration
  def self.up
    add_column    :postings, :commented_at, :datetime
    add_column    :postings, :primed_at,    :datetime

    add_column    :publications, :parent_id,   :integer
    rename_column :publications, :resource_id, :posting_id
    remove_column :publications, :resource_type
    remove_column :publications, :updated_at

    ActiveRecord::Base.record_timestamps = false
    ActiveRecord::Base.transaction do
      say_with_time 'initialized postings primed_at' do
        Posting::Base.roots.find_each do |posting|
          posting.class.update_all(
            { :commented_at => last_commented_at(posting),
              :primed_at    => latest_primed_at(posting) },
            { :id => posting[:id] })
        end
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    add_column    :publications, :updated_at, :datetime
    add_column    :publications, :resource_type, :string
    rename_column :publications, :posting_id, :resource_id

    remove_column :postings, :commented_at
    remove_column :postings, :primed_at

    ActiveRecord::Base.record_timestamps = false
    Publication.reset_column_information
    Publication.transaction do
      say_with_time 'initializing publication updated_at' do
        Publication.find_each do |publication|
          publication.class.update_all(
            { :updated_at    => publication.created_at,
              :resource_type => 'Posting::Base' },
            { :id => publication[:id] })
        end
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  private

  def self.last_commented_at(posting)
    comments = posting.comments.published.order('created_at DESC')
    if comments.present?
      last_commented_at = comments.first.created_at
      comments.inject(last_commented_at) do |memo, comment|
        commented_at = last_commented_at(comment)
        commented_at && (memo < commented_at) ? commented_at : memo
      end
    else
      posting.is_a?(Posting::Comment) ? posting.created_at : nil
    end
  end

  def self.latest_primed_at(posting)
    posting.commented_at || posting.created_at
  end

end

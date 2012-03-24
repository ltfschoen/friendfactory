class AddPrimedAtToPostings < ActiveRecord::Migration
  def self.up
    add_column    :postings, :commented_at,   :datetime
    add_column    :postings, :primed_at,      :datetime
    add_column    :postings, :children_count, :integer

    add_column    :publications, :parent_id,   :integer
    rename_column :publications, :resource_id, :posting_id
    remove_column :publications, :resource_type
    remove_column :publications, :updated_at

    ActiveRecord::Base.record_timestamps = false
    ActiveRecord::Base.transaction do
      say_with_time 'initialized postings primed_at' do
        Posting::Base.where(:parent_id => nil).all.each do |posting|
          posting.commented_at = last_commented_at(posting)
          posting.primed_at = latest_primed_at(posting)
          posting.save(:validate => false)
        end
      end

      say_with_time "publishing comments to their root postings' waves" do
        Posting::Comment.where('parent_id IS NOT NULL').all.each do |comment|
          if parent = comment.parent
            parent.send(:publish_child_to_parents_waves, comment)
          else
            raise comment.inspect
          end
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
    remove_column :postings, :children_count

    ActiveRecord::Base.record_timestamps = false
    Publication.reset_column_information

    Publication.transaction do
      say_with_time 'initializing publication updated_at' do
        Publication.all.each do |publication|
          publication.updated_at = publication.created_at
          publication.resource_type = 'Posting::Base'
          publication.save(:validate => false)
        end
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  private

  def self.last_commented_at(posting)
    comments = posting.comments.order('`created_at` DESC')
    if comments.present?
      last_commented_at = comments.first.created_at
      comments.inject(last_commented_at) do |memo, comment|
        commented_at = last_commented_at(comment)
        memo < commented_at ? commented_at : memo
      end
    else
      posting.is_a?(Posting::Comment) ? posting.created_at : nil
    end
  end

  def self.latest_primed_at(posting)    
    posting.commented_at || posting.created_at
  end

end

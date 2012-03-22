class Posting::WaveProxy < Posting::Base
  belongs_to :resource, :class_name => 'Wave::Base', :foreign_key => 'resource_id'

  def comments_with_resource
    if posting = resource.postings.first
      posting.comments.scoped
    else
      comments_without_resource.scoped
    end
  end

  alias_method_chain :comments, :resource

end
class Posting::WaveProxy < Posting::Base

  acts_as_commentable

  belongs_to :resource, :class_name => 'Wave::Base', :foreign_key => 'resource_id'

  def children_with_resource
    if resource && posting = resource.postings.first
      posting.children.scoped
    else
      children_without_resource.scoped
    end
  end

  alias_method_chain :children, :resource

end
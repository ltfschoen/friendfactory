module Wave::CommunityHelper
  include ActsAsTaggableOn::TagsHelper

  def render_community_posting(posting)
    render_posting(posting)
  end
end

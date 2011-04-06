module Wave::InvitationsHelper

  MaximumDefaultImages = 9
  
  def render_photo_grid(invitation_postings)
    invited_avatar_image_tags(invitation_postings, default_image_tags(MaximumDefaultImages)).join.html_safe
  end

  private

  def default_image_tags(max)
    image_tags = []
    Array.new.tap do |image_tags|
      1.upto(max) do |idx|
        css_class = [ 'thumb', (idx % 3 == 0) ? 'omega' : nil ].compact * ' '
        image_tags << empty_image_tag(:class => css_class, :site => false)
      end
    end
  end
  
  def invited_avatar_image_tags(invitation_postings, image_tags)
    invitation_postings.each_with_index do |posting, idx|
      css_class = [ 'thumb', ((idx+1) % 3 == 0) ? 'omega' : nil ].compact * ' '      
      image_tags[idx] = avatar_or_placeholder_image_tag(posting, :class => css_class)
    end
    image_tags
  end
  
  def avatar_or_placeholder_image_tag(posting, opts = {})
    if posting.accepted? && posting.invitee
      avatar_image_tag(posting.invitee, opts)
    else
      placeholder_image_tag(opts)
    end      
  end
    
end

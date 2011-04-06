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
        css_class = [ 'thumb', (idx % 3 == 0) ? 'omega' : '' ].compact * ' '
        image_tags << image_tag('friskyfactory/ffffff.gif', :class => css_class, :site => false)
      end
    end
  end
  
  def invited_avatar_image_tags(invitation_postings, image_tags)
    invitation_postings.each_with_index do |posting, idx|
      css_class = [ 'thumb', ((idx+1) % 3 == 0) ? 'omega' : '' ].compact * ' '      
      image_tags[idx] = avatar_image_tag(posting.invitee, :class => css_class) if posting.accepted?
    end
    image_tags
  end
    
end

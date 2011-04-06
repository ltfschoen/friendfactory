module Wave::InvitationsHelper

  MaximumDefaultImages = 9
  
  def render_photo_grid(wave, invitation_postings)
    invited_avatar_image_tags(wave, invitation_postings, default_image_tags(wave, MaximumDefaultImages)).join.html_safe
  end

  def avatar_or_placeholder_image_tag(wave, posting, opts = {})
    if posting.accepted? && posting.invitee
      avatar_image_tag(posting.invitee, opts)
    else
      link_to(placeholder_image_tag(opts), edit_wave_posting_invitation_path(wave, posting), :class => 'edit_posting_invitation')
    end
  end

  private

  def invited_avatar_image_tags(wave, invitation_postings, image_tags)
    invitation_postings.each_with_index do |posting, idx|
      css_class = (idx+1) % 3 == 0 ? 'omega' : nil
      image_tags[idx] = content_tag(:li, avatar_or_placeholder_image_tag(wave, posting, :class => 'thumb'), :class => css_class)
    end
    image_tags
  end

  def default_image_tags(wave, max)
    Array.new.tap do |image_tags|
      1.upto(max) do |idx|
        css_class = idx % 3 == 0 ? 'omega' : nil
        image_tags << list_item_tag_with_empty_image(wave, :class => css_class)
      end
    end
  end
      
  def list_item_tag_with_empty_image(wave, opts)
    css_class = opts[:class]
    image_tag = empty_image_tag(:class => 'thumb', :site => false)
    anchor_tag = link_to(image_tag, new_wave_posting_invitation_path(wave), :class => 'new_posting_invitation')
    content_tag(:li, anchor_tag, :class => css_class)
  end
    
end

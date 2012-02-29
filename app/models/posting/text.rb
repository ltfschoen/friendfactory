class Posting::Text < Posting::Base

  def body=(text)
    sanitize_text = tag_helper.sanitize(text)
    self[:body] = sanitize_text
    self[:subject] = sanitize_text.blank? ? '' : BlueCloth.new(sanitize_text).to_html
  end

  private

  def tag_helper
    TagHelper.instance
  end

  class TagHelper
    include Singleton
    include ActionView::Helpers::SanitizeHelper
  end

end
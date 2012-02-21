class Posting::Text < Posting::Base
  def body=(text)
    self[:body] = text
    self[:subject] = BlueCloth.new(text).to_html
  end
end
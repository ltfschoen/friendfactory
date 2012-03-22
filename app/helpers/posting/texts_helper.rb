module Posting::TextsHelper

  PostingTextMaximumLength = 200

  def crop_text_posting?(posting)
    posting.body.length > PostingTextMaximumLength
  end

  def show_digest?
    params[:digest] && params[:digest] == '1'
  end

end
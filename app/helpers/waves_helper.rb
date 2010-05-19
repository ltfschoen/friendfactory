module WavesHelper

  def posting_sidebar(posting)
    case posting.class.name
      when 'Posting::Message' : 'Private'
      else 'Public'
    end
  end

end

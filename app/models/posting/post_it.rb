class Posting::PostIt < Posting::Base
  publish_to :wave => Wave::Profile  
end

# class LinksController < WavesController
# 
#   before_filter :require_user
# 
#   def create
#     wave = Wave::Base.find_by_id(params[:wave_id])    
#     if wave.present?
#       link = params[:posting_link].strip
#       link = "http://#{link}" unless link.match(/^http:\/\//)
#       @posting = Posting::Link.create(link) 
#       wave.postings << @posting
#     end
#     respond_to do |format|      
#       format.js
#     end
#   end
# 
# end

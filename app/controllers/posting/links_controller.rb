class Posting::LinksController < Posting::BaseController

  @@embedly_api = Embedly::API.new :key => EmbedlyKey

  def create
    @posting = nil
    if wave = current_site.waves.find_by_id(params[:wave_id])
      @posting = Posting::Link.new(params[:posting_link]) do |link|
        link.site = current_site
        link.user = current_user
        link.sticky_until = params[:posting_link][:sticky_until] if current_user.admin?
        link.embedify
        link.build_photos
      end
      if wave.postings << @posting
        current_user.profile(current_site).postings << @posting
        @posting.publish!
        @posting.children(true)
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end

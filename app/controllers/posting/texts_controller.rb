class Posting::TextsController < Posting::BaseController

  before_filter :require_user

  def new
    @wave = Wave::Base.find_by_id(params[:wave_id])
  end

  def create
    @posting = nil
    if wave = current_site.waves.find_by_id(params[:wave_id])
      @posting = Posting::Text.new(params[:posting_text]) do |text|
        text.user = current_user
        text.sticky_until = params[:posting_text][:sticky_until] if current_user.admin?
      end
      if @posting.save
        wave.postings << @posting
        @posting.publish!
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end

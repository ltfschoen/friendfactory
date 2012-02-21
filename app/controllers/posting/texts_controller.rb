class Posting::TextsController < Posting::BaseController

  before_filter :require_user

  def new
    @wave = Wave::Base.find_by_id(params[:wave_id])
  end

  def create
    wave = current_site.waves.find_by_id(params[:wave_id])
    add_posting_to_wave(new_text_posting, wave)
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def new_text_posting
    @posting ||= begin
      Posting::Text.new(params[:posting_text]) do |text|
        text.subject = BlueCloth.new(text.body).to_html
        text.site = current_site
        text.user = current_user
        text.sticky_until = params[:posting_text][:sticky_until] if current_user.admin?
      end
    end
  end

  def add_posting_to_wave(posting, wave)
    ActiveRecord::Base.transaction do
      if wave.postings << posting
        posting.publish!
      end
    end
  end

end

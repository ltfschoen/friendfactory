module PostingsHelper
  def render_post_it(object)
    render(:partial => '/posting/post_it', :locals => { :posting => object })
  end
end

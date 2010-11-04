module PostingsHelper
  def render_post_it(object)
    render(:partial => '/posting/post_it', :locals => { :posting => object })
  end
  
  def render_postings(collection)
    render :partial => 'posting/posting', :collection => collection
  end
end

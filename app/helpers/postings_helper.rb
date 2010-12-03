module PostingsHelper
  def render_post_it(object, opts={})
    render(:partial => 'posting/post_it', :locals => { :posting => object, :message => opts[:message] })
  end
  
  def render_postings(collection)
    render :partial => 'posting/posting', :collection => collection
  end
end

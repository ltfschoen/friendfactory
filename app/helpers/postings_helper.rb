module PostingsHelper
  def render_post_it(object, opts={})
    render(:partial => 'postings/post_it', :locals => { :posting => object, :message => opts[:message] })
  end
  
  def render_postings(collection)
    render :partial => 'postings/posting', :collection => collection
  end
end

jQuery(function($){
	
	// Comment forms
	 $('a.new_posting_comment').live('click', function(event) {
	   event.preventDefault();
	   $(this).hide().next('.comment-bubble').show();
	 });

	 $('.comment-bubble form').bind('ajax:before', function(event) {
	   $(this).hide().next('.new_posting_comment_spinner').show();
	 });

	 $('form.new_posting_comment')
	    .find('button.cancel').live('click', function(event) {
	      event.preventDefault();
	      $(this).closest('.comment-bubble').hide().prev('a.new_posting_comment').show();
	   });
	
});

jQuery(function($) {
	
	$('a.new_posting_comment').live('click', function(event) {
		event.preventDefault();
		$(this).fadeOut(function() {
			$(this).next('.posting_comment')
				.css({ opacity: 0.0 })
				.slideDown(function() {
					$(this).fadeTo('fast', 1.0);
				});
		});
	});

	$('.content form.new_posting_comment')
		.bind('ajax:before', function(event) {
			$(this).fadeOut(); // .next('.new_posting_comment_spinner').show();
	});

	 $('form.new_posting_comment')
		.find('button.cancel').live('click', function(event) {
			event.preventDefault();
			$(this).closest('.posting_comment').fadeTo('fast', 0.0, function() {
				$(this)
					.slideUp()
					.prev('a.new_posting_comment')
					.fadeIn();
			});
	   });	
});

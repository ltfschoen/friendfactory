jQuery(function($) {

	$('.posting_comments').masonry({
		singleMode: true, 
		itemSelector: '.posting_comment:visible'
	});

	$('a.new_posting_comment').live('click', function(event) {
		event.preventDefault();
		$(this).fadeTo('fast', 0.0, function() {
			$(this).closest('.posting')
				.find('.posting_comment.form')
					.css({ opacity: 0.0 })
					.slideDown(function() {
						$(this).fadeTo('fast', 1.0)
							.find('textarea')
								.val('').focus();
					});				
		});
	});


	$('form.new_posting_comment')
		.buttonize()
		
		.bind('ajax:before', function(event) {
			$(this).find('.button-bar')
				.css({ opacity: 0.0 });
		})
		
		.bind('ajax:complete', function(event) {
			$(this).find('.button-bar')
				.css({ opacity: 1.0 });
		})
		
		.find('textarea')
			.autoResize({ extraSpace: 12, limit: 152 })
		.end()
		
		.find('button.cancel')
			.live('click', function(event) {
				event.preventDefault();
				$(this).closest('.posting_comment')
					.fadeTo('fast', 0.0, function() {
						$(this).slideUp(function(){
							$(this).prev('a.new_posting_comment').fadeTo('fast', 1.0);
						});
					});
			});

});

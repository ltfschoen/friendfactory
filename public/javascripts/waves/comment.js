jQuery(function($) {

	$('.posting_comments').masonry({
		singleMode: true, 
		itemSelector: '.posting_comment:visible'
	});
	
	$('button', 'form.new_posting_comment').button({ text: false })
	
	$('.posting_comment').bind('pulse', function(event) {
		$(this).toggleClass('pulse');
	});

	
	$('a.new_posting_comment').live('click', function(event) {
		event.preventDefault();
		$(this)
			.fadeTo('fast', 0.0, function() {
				$(this)
					.closest('.posting')
					.find('.posting_comment.form')
						.css({ opacity: 0.0 })
						.slideDown(function() {
							$(this)
								.fadeTo('fast', 1.0)
								.find('textarea')
									.val('').focus();
						});				
			})
	});


	$('form.new_posting_comment')
		.bind('ajax:before', function(event) {
			$(this)
				.find('.button-bar')
					.css({ opacity: 0.0 })
				.end()
				.closest('.posting_comment')
				.trigger('pulse');
		})
		.bind('ajax:complete', function(event) {
			$(this)
				.find('.button-bar')
					.css({ opacity: 1.0 })
				.end()
				.closest('.posting_comment')
				.trigger('pulse');
		})
		.find('textarea')
			.autoResize({ extraSpace: 12, limit: 152 })
		.end()
		.find('button.cancel')
			.live('click', function(event) {
				event.preventDefault();
				$(this)
					.closest('.posting_comment')
					.fadeTo('fast', 0.0, function() {
						$(this)
							.slideUp()
							.prev('a.new_posting_comment')
							.fadeTo('fast', 1.0);
					});
			});

});

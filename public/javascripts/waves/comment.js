jQuery(function($) {
	
	$('.posting_comment').bind('pulse', function(event) {
		$(this).toggleClass('pulse');
	});

	
	$('a.new_posting_comment').live('click', function(event) {
		event.preventDefault();
		$(this)
			.fadeTo('fast', 0.0)
			.next('.posting_comment')
				.css({ opacity: 0.0 })
				.slideDown(function() {
					$(this)
						.fadeTo('fast', 1.0)
						.find('textarea')
							.focus();
				});					
	});


	$('form.new_posting_comment')
		.bind('ajax:before', function(event) {
			$(this)
				.closest('.posting_comment')
				.trigger('pulse');
		})
		.bind('ajax:complete', function(event) {
			$(this)
				.closest('.posting_comment')
				.trigger('pulse');
		})
		.find('button.cancel')
			.live('click', function(event) {
				event.preventDefault();
				$(this)
					.closest('.posting_comment')
					.fadeTo('fast', 0.5, function() {
						$(this)
							.slideUp()
							.prev('a.new_posting_comment')
							.fadeTo('fast', 1.0);
							// .css({ opacity: 1.0 });
							// .show();
							// .fadeIn('fast', 1.0);
					});
			});	

});

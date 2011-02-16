jQuery(function($) {

	$('form.new_posting_post_it')
		.live('ajax:before', function(event) {
			$(this).find('.button-bar')
				.css({ opacity: 0.0 });
		})
		.find('button.cancel')
			.live('click', function(event) {
				event.preventDefault();
				$(this).closest('.button-bar')
					.css({ opacity: 0.0 })
					.closest('form')
					.fadeTo('slow', 0.0)
					.animate({ width: 0 }, 'slow', function() {
						$(this)
							.closest('ul.posting_post_its')
								.find('li:last .canvas')
									.fadeTo('slow', 1.0)
								.end()
							.end()
							.remove();
					});
				
				$('a[rel="#posting_post_it"]', 'ul.wave.community.nav')
					.closest('li')
						.removeClass('current');			
			});

});

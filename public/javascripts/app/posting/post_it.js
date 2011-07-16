jQuery(function($) {

	$('.posting_post_it.form').live('init', function() {
		$('form.new_posting_post_it', this)
			.buttonize()
		
			.live('ajax:before', function(event) {
				$(this).find('.button-bar')
					.css({ opacity: 0.0 });
			})

			.live('ajax:complete', function(event) {
				$(this).find('.button-bar')
					.css({ opacity: 1.0 });
			})
			
			.find('button.cancel')			
				.live('click', function(event) {
					$(this).closest('.button-bar')
						.hide()
						.closest('form')
							.fadeTo('fast', 0.0, function() {
								$(this).animate({ width: 0 }, 900, 'easeOutBounce', function() {
									$(this).closest('ul.posting_post_its')
										.find('li:last .canvas')
											.fadeTo('slow', 1.0)
										.end()
									.end()
									.closest('li').remove();
								});
							});				
					$('a[rel="#posting_post_it"]', 'ul.wave.nav')
						.closest('li').removeClass('current');					
					return false;
				});
	});

});

jQuery(function($) {

	$('a[rel="#posting_post_it"]', 'ul.wave.nav')
		.click(function(event) {
			event.preventDefault();
			var $this = $(this);
			
			if (!$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li')
					.addClass('current');					

				if ($('ul.posting_post_its').length === 0) {
					$('<ul class="posting_post_its clearfix"></ul>')
						.css({ opacity: 0.0 })
						.hide()
						.insertBefore('ul.postings:first')
						.delay(1200)
						.slideDown(function() {
							$(this).fadeTo('slow', 1.0);
						});
				}

				$($this.attr('rel'))
					.find('form')
						.clone()
						.css({ width: 0, opacity: 0.0 })
						.prependTo('ul.posting_post_its:first')
						.wrap('<li>');

				setTimeout(function() {
					$('li:eq(5)', 'ul.posting_post_its:first')
						.find('.canvas')
							.hide('drop', { direction: 'down' }, 900, function() {
								$('form', 'ul.posting_post_its:first li:first')
										.delay(150)
										.animate({ width: 187 }, 'slow', function() {
											$(this).fadeTo('slow', 1.0)
												.find('textarea').focus();
										});
							});
				}, 1100);				
				
			} else {
				$this.trigger('shake');
			}			
		});


	$('form.new_posting_post_it', '.tab_content')
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
								.closest('li').remove();
						});
				
				$('a[rel="#posting_post_it"]', 'ul.wave.nav')
					.closest('li').removeClass('current');
					
				return false;
			});

});

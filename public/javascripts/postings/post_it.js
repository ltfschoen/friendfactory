jQuery(function($) {

	function insertPostItsContainer() {
		$('<ul class="posting_post_its clearfix"></ul>')
			// .css({ opacity: 0.0 })
			// .hide()
			.insertBefore('ul.postings:first')
			.delay(1200)
			.slideDown(function() {
				$(this).show();
				// $(this).fadeTo('slow', 1.0);
			});		
	}
	
	
	function insertPostIt(postIt) {
		return $(postIt).clone()
			.css({ width: 0, opacity: 0.0 })
			.prependTo('ul.posting_post_its:first')
			.wrap('<li>');
	}
	
	
	function revealFirstPostIt(postIt) {
		insertPostIt(postIt);		
		$('form', 'ul.posting_post_its:first li:first')
			.animate({ width: 187 }, 'slow', function() {
				$(this).fadeTo('fast', 1.0)
					.find('textarea').focus();
			});
	}


	function dropLastPostIt() {
		$('.canvas', 'ul.posting_post_its:first li:eq(4)')
			.hide('drop', { direction: 'down' }, 900);
	}


	$('a[rel="#posting_post_it"]', 'ul.wave.nav')
		.click(function(event) {
			event.preventDefault();
			var $this = $(this);
			
			if (true || !$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li').addClass('current');					

				if ($('ul.posting_post_its').length === 0) {
					insertPostItsContainer();
				}				
				
				setTimeout(dropLastPostIt, 1100);

				var postItForm = $($this.attr('rel')).find('form');
				setTimeout(function(){ revealFirstPostIt(postItForm) }, 2000);
				
			} else {
				$this.trigger('shake');
			}			
		});


	$('form.new_posting_post_it')
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

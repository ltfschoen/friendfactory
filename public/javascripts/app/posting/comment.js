jQuery(function($) {

	$('.posting_comment').live('init', function(event) {		
		var $this = $(this);

		$this
			.find('form.new_posting_comment')
				.hide()
				.bind('ajax:before', function(event) {
					$(this).find('.button-bar')
						.css({ opacity: 0.0 });
				})
				.bind('ajax:complete', function(event) {
					$(this)
						.find('.button-bar')
						.css({ opacity: 1.0 });
				})
				
				.find('textarea')
					.autoResize({ extraSpace: 0, limit: 130 })
				.end()
				
				.find('button.cancel')
					.bind('click', function(event) {
						event.preventDefault();				
						$(event.target).closest('form')
							.css({ opacity: 0.0 })
							.trigger('reset')
							.slideUp('fast', function() {
								$(this).closest('.posting-container')
									.find('a.new_posting_comment')
										.fadeTo('fast', 1.0);
							});
						})
				.end()
			.end()

			.find('a.new_posting_comment')
				.live('click', function(event) {
					var $this = $(this);						
					event.preventDefault();			
					$this
						.fadeTo('fast', 0.0, function() {
							$this
								.closest('.posting-container')
								.find('.posting_comment form')
									.css({ opacity: 0.0 })
									.slideDown('fast')					
									.fadeTo('fast', 1.0)
									.find('textarea').focus();					
						});
					$.waypoints('refresh');			
				});

		$this.buttonize();		
		return false;		
	});

});

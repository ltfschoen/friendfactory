(function($) {

	$.fn.comment = function() {
		var $this = $(this);
			
		$this
			.hide()
			.find('form.new_posting_comment')

				.bind('ajax:before', function(event) {
					$(this).find('.button-bar')
						.css({ opacity: 0.0 });
				})

				.bind('ajax:complete', function(event) {
					$(this).find('.button-bar')
						.css({ opacity: 1.0 });
				})

				.find('textarea')
					.autoResize({ extraSpace: 0, limit: 130 })
				.end()

				.find('button.cancel')
					.bind('click', function(event) {
						event.preventDefault();					
						$(event.target).closest('.posting_comment')
							.css({ opacity: 0.0 })
							.slideUp('fast', function() {
								$(this).closest('.posting-container')
									.find('a.new_posting_comment')
										.fadeTo('fast', 1.0);
							});
						});

		$this.buttonize();
		return $this;
	};
		
})(jQuery);

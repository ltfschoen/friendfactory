(function($) {

	$.fn.comment = function (callback) {
		var $this = $(this);
	
		$this.find('form.new_posting_comment')
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
				.bind('click', function(event) {
					event.preventDefault();
					if (callback !== undefined) { callback(event); }
				});
				
		$this.buttonize();
		return $this;
	};
		
})(jQuery);

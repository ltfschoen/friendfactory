jQuery(function($) {

	$('.posting_text.form').live('init', function(event) {
		$('form.new_posting_text', this)
			.buttonize()
			
			.bind('reset', function() {
				$(this).find('input, button').removeAttr('disabled');
				return $(this);
			})

			.live('ajax:beforeSend', function() {
				$(this)
					.find('input, button').attr('disabled', 'disabled').end()
					.find('.canvas').pulse();
			})

			.live('ajax:complete', function() {
				$('.canvas', this).pulse();
			})

			.find('textarea').placehold().end()
						
			.find('button.cancel')
				.bind('click', function() {
					var $this = $(this);
					$this.closest('form')
						.trigger('reset')
						.hideNavContent();
					return false;
				});
	});

});

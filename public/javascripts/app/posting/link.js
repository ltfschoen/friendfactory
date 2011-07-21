jQuery(function($) {		

	$('form.new_posting_link').live('init', function(event) {
		$(this)
			.buttonize()			
			.find('input[type="text"]').placehold().end()
			
			.live('reset', function() {
				$(this)
					.find('input').removeAttr('disabled').end()
					.find('button').removeAttr('disabled').end()
					.find('.spinner').attr('style', 'visibility:hidden');
			})
		
			.live('ajax:loading', function() {
				$(this)
					.find('input').attr('disabled', 'disabled').end()
					.find('button').attr('disabled', 'disabled').end()
					.find('.spinner').attr('style', 'visibility:visible');
			})
		
			.find('button.cancel')
				.bind('click', function() {
					$(this).hideNavContent().closest('form').trigger('reset');				
					return false;
				});
	});

});
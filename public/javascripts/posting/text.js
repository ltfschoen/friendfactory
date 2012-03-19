jQuery(function($) {

	$('form#new_posting_text')
		.bind('open', function () {
			$(this)
				.find('textarea').attr('style', '').end()
				.find('.preview .body').html('');
			$.hideAllReactions();
		})

		.bind('close', function () {
			$.showAllReactions();
		});

});

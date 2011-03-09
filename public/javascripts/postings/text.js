jQuery(function($) {

	$('form.new_posting_text', '.tab_content')
		.buttonize()

		.find('button.cancel')
			.bind('click', function() {
				$(this).hideTabContent();
				return false;
			});

});

jQuery(function($) {
	$('.admin.invitation')
		.buttonize()	
		.find('form')
			.bind('ajax:before', function() {
				$(this).find('.spinner').css({ 'visibility': 'visible' });
			})
		
			.bind('ajax:success', function(event, status) {
				var success = status['updated'];
				$(this).find('.spinner').css({ 'visibility': 'hidden' });
			})
		
			.find("select[name='posting_invitation[state]']")
				.change(function() {
					$(this).closest('form').trigger('submit');
				});
	
	$('.admin.site').buttonize({ text: true });

});

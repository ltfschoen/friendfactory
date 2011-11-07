jQuery(function($) {
	
	// Personal Wave
	$('.profiles.show')
		.find('.headshot-container').headshot();
	
	// Edit profile
	$('input[name="user[emailable]"]').bind('ajax:before', function() {
		$(this).data('params', this.name + '=' + this.checked);
		return true;
	});
});

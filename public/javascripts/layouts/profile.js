jQuery(function($) {

	// Personal Wave
	$('.profiles.show')
		.find('.headshot-container').headshot();

	// Initialize forms
	$('input[type="text"], textarea', 'form').placeholder();

	// Edit profile
	$('input[name="user[emailable]"]').bind('ajax:before', function() {
		$(this).data('params', this.name + '=' + this.checked);
		return true;
	});

});

jQuery(function($) {

	$('input[type="text"], textarea').placeholder();

	$('input[name="user[emailable]"]').bind('ajax:before', function() {
		$(this).data('params', this.name + '=' + this.checked);
		return true;
	});

});

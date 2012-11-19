jQuery(function($) {

	$('select[name="personage[id]"]', '#sidebar').bind('ajax:before', function() {
		var id = $(this).find('option').eq(this.selectedIndex).attr('value');
		$(this).data('url', '/profiles/' + id + '/switch');
		return true;
	});

});

jQuery(function($) {
	$('.posting_avatar').live('init', function(event) {
		$('div.polaroid', this).polaroid();
	});
});

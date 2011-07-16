jQuery(function($) {

	$('.posting_avatar').live('init', function(event) {
		$('.polaroid-container > .polaroid', this).polaroid();
	});

});

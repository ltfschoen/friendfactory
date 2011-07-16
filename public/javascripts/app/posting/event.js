jQuery(function($) {

	$('.posting_event').live('init', function(event) {
		$('.ticket-container > .ticket', this).ticket();
	});

});

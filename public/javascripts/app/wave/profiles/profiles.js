jQuery(function($) {	
	$('div.polaroid', '.roll_call').polaroid();
	$('.posting', '.wave_profile').trigger('init');
});

$(window).load(function() {
	$('.posting_photos', '.wave_community')
		.masonry({
			singleMode: false,
			columnWidth: 1,
			itemSelector: 'li',
			resizeable: false
		});

	$('.posting_comments', '.wave_community')
		.masonry({
			singleMode: false,
			columnWidth: 222,
			itemSelector: 'li',
			resizeable: false
		});
});

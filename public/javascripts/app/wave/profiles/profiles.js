jQuery(function($) {	
	$('div.polaroid').polaroid();
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

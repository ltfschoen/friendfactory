jQuery(function($) {

	$('.portrait a[href^="/wave/profiles"]')
		.live('click', function(event) {
			var $this = $(this),
				url = $this.attr('href');

			event.preventDefault();
			$.get(url, function(data, status, xhr) {
				$(data)
					.addClass('floating')
					.appendTo('#floating')
					.position({
						my: 'left center',
						of: event,
						offset: '30 0',
						collision: 'fit' })
					.draggable()
					.find('div.headshot').headshot();
			});
		});

});

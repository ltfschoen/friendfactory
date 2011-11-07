jQuery(function($) {
	var idx = 0,
		$headshots = $('div.headshot'),

		flipNext = function(headshot) {
			headshot.onFlip = undefined;

			if (idx < 3) {
				$headshots.eq(++idx)
					.find('.front.face a[data-pane-name="conversation"]')
						.trigger('click');
			} else {
				$headshots.each(function() {
					this.onFlip = undefined;
				})
			}
		};

	$headshots.headshot({ onFlip: flipNext })
		.filter(':first')
			.find('.front.face a[data-pane-name="conversation"]')
				.trigger('click');

});

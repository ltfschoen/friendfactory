jQuery(window).load(function() {
	var callback = function ($headshot) {
		var $container = $headshot.closest('.headshot-container');
		$container.fadeTo('slow', 0.0, function () {
			$container.animate({ width: 0 }, 'fast', function () {
				$container.remove();
				return true;
			});
		});
	};

	$('div.headshot').headshot({ pane: 'conversation', setFocus: false, beforeClose: callback });
});
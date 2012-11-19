jQuery(function($) {
	$('.noscript a.close').click(function () {
		var $this = $(this),
			$noscript = $this.closest('.noscript');

		document.cookie = "ackNoBrowser=true";
		$noscript.fadeTo('fast', 0.0, function () {
			$noscript.slideUp('fast', function () {
				$noscript.remove();
			});
		});
		return false;
	});
});
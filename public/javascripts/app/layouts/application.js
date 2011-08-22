if (/chrome/.test(navigator.userAgent.toLowerCase())) {
	jQuery.browser.chrome = true;
	jQuery.browser.safari = false;
}

if (jQuery.browser.chrome) {
	$('html').removeClass('csstransforms3d');
}

jQuery(function($) {
	$('.posting-container').live('init', function(event) {
		if (event.target === this) {
			$('.posting', this).trigger('init');
		}
	});

	$('form').live('reset', function(event) {
		$('textarea, input', this).placehold();
	});

});

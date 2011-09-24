jQuery.support.csstransforms3d = Modernizr.csstransforms3d;

if (/chrome/.test(navigator.userAgent.toLowerCase())) {
	jQuery.browser.chrome = true;
	jQuery.browser.safari = false;
}

if (jQuery.browser.chrome || (jQuery.browser.safari && (parseInt(jQuery.browser.version.match(/^\d{3}/)) < 534))) {
	Modernizr.csstransforms3d = false;
}

if (!Modernizr.csstransforms3d) {
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

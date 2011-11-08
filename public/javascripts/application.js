(function($) {

	if (/chrome/.test(navigator.userAgent.toLowerCase())) {
		$.browser.chrome = true;
		$.browser.safari = false;
		Modernizr.csstransforms3d = false;
		$('html').removeClass('csstransforms3d').addClass('no-csstransforms3d');
	}

	$.support.csstransforms3d = Modernizr.csstransforms3d;

	$.getId = function(element) {
		var id = $(element).attr('id'),
			match;
		if ((id !== undefined) && (match = id.match(/\d{1,}$/))) match = match[0];
		return match;
	};

	$.fn.getId = function() {
		return $.getId(this);
	};

})(jQuery);


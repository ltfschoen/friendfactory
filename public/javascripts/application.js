if (/chrome/.test(navigator.userAgent.toLowerCase())) {
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}


(function($) {

	$.fn.buttonize = function(customOptions) {
		var options = $.extend({}, $.fn.buttonize.defaults, customOptions || {});
		return $(this)
			.find('button[type="submit"]')
				.button({ icons: { primary: 'ui-icon-check' }, text: options.text })
			.end()

			.find('button.cancel')
				.button({ icons: { primary: 'ui-icon-close' }, text: options.text })
			.end();
	};
	
	$.fn.buttonize.defaults = {
		text: false
	};
	
})(jQuery);

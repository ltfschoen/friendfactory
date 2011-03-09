if (/chrome/.test(navigator.userAgent.toLowerCase())) {
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}

// jQuery(function($) {
//  	$('button.cancel, a.cancel')
// 		.button({ icons: { primary: 'ui-icon-close' }});	
// 	$('input, textarea').placehold();	
// });

(function($) {
	$.fn.buttonize = function() {
		return $(this)
			.find('button[type="submit"]')
				.button({ icons: { primary: 'ui-icon-check' }, text: false })
			.end()

			.find('button.cancel')
				.button({ icons: { primary: 'ui-icon-close' }, text: false })
			.end();
	};
})(jQuery);

if (/chrome/.test(navigator.userAgent.toLowerCase())) {
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}

jQuery(document).ready(function($) {
 	$('button.cancel, a.cancel')
		.button({ icons: { primary: 'ui-icon-close' }});
	
	$('input, textarea').placehold();
});




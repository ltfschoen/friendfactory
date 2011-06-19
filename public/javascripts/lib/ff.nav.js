(function($) {
	
	$.fn.hideNavContent = function() {
		var $navContent = $(this).closest('.tab_content');
	
		$('a[rel="#' + $navContent.attr('id') +'"]', 'ul.wave.nav')
			.closest('li')
			.removeClass('current');
	
		$navContent.fadeTo('fast', 0.0, function() {
			$navContent.slideUp(800, 'easeOutBounce');
		});
	}
	
	$.fn.hideTabContent = $.fn.hideNavContent;
	
})(jQuery);

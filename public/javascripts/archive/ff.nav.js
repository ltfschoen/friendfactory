(function($) {
	
	$.fn.hideNavContent = function() {
		var $this = $(this),
			$navContent = $this.closest('.tab_content');
	
		$('a[rel="#' + $navContent.attr('id') +'"]', 'ul.wave.nav')
			.closest('li')
			.removeClass('current');
	
		$navContent.fadeTo('fast', 0.0, function() {
			$navContent.slideUp(800, 'easeOutBounce');
		});
		
		return $this;
	}
	
	$.fn.hideTabContent = $.fn.hideNavContent;
	
})(jQuery);

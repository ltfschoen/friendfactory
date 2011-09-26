(function($) {

	$.fn.headshot = function(options) {
		var $headshot = $(this);
		
		$headshot.toggle(function() {
			$(this).addClass('flip')
		}, function() {
			$(this).removeClass('flip')
		});
	};
	
})(jQuery);

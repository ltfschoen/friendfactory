(function($) {

	$.fn.bringToFront = function() {		
		
		var maxz = 0;
		$(this).siblings('.floating')
			.each(function() {
				maxz = Math.max(maxz, parseInt($(this).css('z-index')));
		});		
		return $(this).css('z-index', (maxz + 1));
		
	} // fn.top

})(jQuery);

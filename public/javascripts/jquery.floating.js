(function($) {

	$.fn.top = function() {		
		var maxz = 0;			
		return $($(this).closest('.floating').siblings('.floating').andSelf())
			.each(function() {
				console.log($(this).css('z-index'));
				maxz = Math.max(maxz, parseInt($(this).css('z-index')));
		}).css('z-index', maxz + 1);		
	} // fn.top

})(jQuery);

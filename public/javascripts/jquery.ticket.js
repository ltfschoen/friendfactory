(function($) {
	
	$.fn.ticket = function() {
		
		if ($.browser.safari) {			
			return this.each(function() {
				$this = $(this); // a ticket				
				$this.click(function(event) {
					$(this).closest('.ticket').toggleClass('flipped');
				});				
			});			
		}// if
		
	} // fn.ticket
	
})(jQuery);

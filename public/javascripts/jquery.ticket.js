(function($) {
	
	$.fn.ticket = function() {
		
		if (Modernizr.csstransforms3d) {
			return this.each(function() {
				$this = $(this); // a ticket				
				$this.click(function(event) {
					$(this).closest('.ticket').toggleClass('flipped');
				});				
			});
			
		} else {			

			return this.each(function() {
				
				$this = $(this); // ticket
				$this.find('.back.face').css('-webkit-transform', 'rotateY(0deg)');
				$this.find('.face-container:eq(1)').hide();
				
				$this.find('.front.face').live('click', function(event) {
					event.preventDefault();					
					var $ticket = $(this).closest('.ticket');
					
					$ticket.flip({
						speed: 300,
						direction: 'lr',
						dontChangeColor: true,
						content: $ticket.find('.face-container:hidden'),
						
						onEnd: function() {
							$ticket.find('.back.face').click(function(event) {
								event.preventDefault();
								$ticket.revertFlip();
							}); // click
						} // onEnd						
					}); // flip
					
				}); // click
			}) //each
			
		} // if
		
	} // fn.ticket
	
})(jQuery);

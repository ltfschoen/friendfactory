(function($) {
	
	$.fn.ticket = function() {
		
		if (Modernizr.csstransforms3d) {
			return this.each(function() {
				$this = $(this); // ticket				
				$this.find('a.flip').click(function(event) {
					event.preventDefault();
					$(this).closest('.ticket').toggleClass('flipped');
				});				
			});
			
		} else {			
			return this.each(function() {				
				$this = $(this); // ticket
				$this.find('.back.face').css('-webkit-transform', 'rotateY(0deg)');
				$this.find('.face-container:eq(1)').hide();
				
				$this.find('.front.face').find('a.flip').live('click', function(event) {
					var $ticket = $(this).closest('.ticket');
					
					event.preventDefault();					
					$ticket.flip({
						speed: 300,
						direction: 'lr',
						dontChangeColor: true,
						color: 'transparent',
						bgColor: 'transparent',
						content: $ticket.find('.face-container:hidden'),						
						onEnd: function() {
							$ticket.find('.back.face').find('a.flip').click(function(event) {
								event.preventDefault();
								$ticket.revertFlip();
							});
						} // onEnd
					}); // flip				
				}); // click
			})			
		}		
	}
	
})(jQuery);

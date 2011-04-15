(function($) {
	
	$.fn.polaroid = function(options) {

		var settings = { 'close-button' : false },
			
			panes = {
				init: function(scrollable, idx) {
					var $pane = $(scrollable.getRoot()).find('.pane:eq(' + idx + ')'),
						pane_name = $pane.data('pane'),
						profileId = $pane.closest('.polaroid').attr('data-profile_id');
					
					$pane.load('/wave/profiles/' + profileId + '/' + pane_name);
				}				
			}
		
		$.extend(settings, options);		
		
		if (Modernizr.csstransforms3d) {
			
			return this.each(function() {							
				$this = $(this); // a polaroid

				if (settings['close-button'] === true) {
					$('a.close', $this).click(function(event) {
						$(event.target).closest('.floating')
							.fadeOut(function() {
								$(this).remove();
							});
						return false;
					});
				}
				
				$this.find('.back.face')
					.css('-webkit-transform', 'rotateY(180deg)')

					.find('.scrollable')
						.scrollable({
							items: 'items',
							keyboard: false,
							next: '',
							prev: '',
							onSeek: function(event, idx) {
								panes.init(this, idx);
							}
						}).navigator()						
					.end()
					
					.find('.buddy-bar a.flip')
						.click(function(event) {
							event.preventDefault();	
							$(this).closest('.polaroid').toggleClass('flipped');
						})
					.end()										
				.end()
				
				.find('.front.face .buddy-bar a.flip')
					.click(function(event) {
						event.preventDefault();	
				
						var idx = $(this).closest('li').index();
						var $polaroid = $(this).closest('.polaroid')
						var $backFace = $polaroid.find('.back.face');
				
						// Manually scroll to correct pane. Have to secretly
						// undo the rotate to do the scroll.							
						$backFace.css('-webkit-transform', 'rotateY(0deg)');
						$backFace.find('.scrollable').scrollable().seekTo(idx, 0);
						$backFace.css('-webkit-transform', 'rotateY(180deg)');
							
						// Do the flip
						$polaroid.toggleClass('flipped');
					})
				.end();
						
			}); // each
			
		} else {
						
			return this.each(function() {				
				$this = $(this); // a polaroid
				
				$this.find('.face-container:eq(1)').hide();
				
				if (settings['close-button'] === true) {
					$('a.close', $this).live('click', function(event) {
						$this.fadeOut();
						$(event.target).closest('.floating').remove();
						return false;
					});
				}				

				$this.find('.front .buddy-bar a.flip').live('click', function(event) {
		    		event.preventDefault();
					
					var $polaroid = $(this).closest('.polaroid');
					$polaroid.data('scrollable-index', $(this).closest('li').index());
					
		    		$polaroid.flip({
						speed: 300,
		      			direction: 'lr',
		      			color: '#FFF',
		      			content: $polaroid.find('.face-container:hidden'),
				
		      			onEnd: function() {
					  		$polaroid.find('.buddy-bar a.flip').click(function(event) {
								event.preventDefault();
								$polaroid.revertFlip();								
							});

							// Make links work on backside
							$polaroid.find('.scrollable').scrollable({
								items: 'items',
								keyboard: false,
								next: '',
								prev: '',							
	      	    				onSeek: function(event, idx) {
									panes.init(this, idx);
	      	    				}
							}).navigator();

							var idx = $polaroid.data('scrollable-index');
							$polaroid.find('.scrollable').scrollable().seekTo(idx ,0);
		      			} // onEnd		
		    		}); // flip
		
		  		}); // live
		
			}); // each
			
		} // if
		
	}; // fn.polaroid
	
})(jQuery);


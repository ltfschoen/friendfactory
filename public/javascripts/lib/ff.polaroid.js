(function($) {

	$.fn.polaroid = function(options) {
		
		var settings = {
				'close-button' : false
			},
			
			panes = {
				init: function(scrollable, idx) {
					var panes = this,
						$pane = $(scrollable.getRoot()).find('.pane:eq(' + idx + ')'),
						paneName = $pane.data('pane'),
						profileId = $pane.closest('.polaroid').attr('data-profile_id');						
					
					$pane.load('/wave/profiles/' + profileId + '/' + paneName, function(event) {
						if (panes[paneName] !== undefined) {
							panes[paneName]($pane);
						}						
					});					
				},
				
				conversation: function($pane) {
					$pane.find('.wave_conversation').chat();
				}
			}
		
		$.extend(settings, options);		
		
		if (Modernizr.csstransforms3d) {			
			return this.each(function() {
				var $this = $(this), // a polaroid
					$backFace = $this.find('.back.face'),
					transitionDuration = $this.css('-webkit-transition-duration');
				
				if (settings['pane'] === undefined) {
					$this.css({ '-webkit-transition-duration': '0s' }).addClass('flipped');					
					$backFace.find('.content').css({ opacity: 0.0 });
				}

				if (settings['close-button'] === true) {
					$('a.close', $this).click(function(event) {
						$(event.target).closest('.floating')
							.fadeOut(function() {
								$(this).remove();
							});
						return false;
					});
				}
				
				$backFace
					// .css('-webkit-transform', 'rotateY(180deg)')
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
							$backFace.find('.content').fadeTo('fast', 0.0);
							$this.css({ '-webkit-transition-duration': transitionDuration }).toggleClass('flipped');
						})
					.end()										
				.end()
				
				.find('.front.face .buddy-bar a.flip')
					.click(function(event) {
						var idx = $(this).closest('li').index();
						event.preventDefault();						

						// Undo the rotate and manually scroll to correct pane.
						$backFace.css('-webkit-transform', 'rotateY(180deg)')
							.find('.scrollable').scrollable().seekTo(idx, 0);
						$backFace.css('-webkit-transform', 'none')
							.find('.content').delay(900).fadeTo('fast', 1.0);													

						$this.css({ '-webkit-transition-duration': transitionDuration }).toggleClass('flipped');
					})
				.end();
				
				if (settings['pane'] !== undefined) {
					$backFace.find('.scrollable').scrollable().seekTo(settings['pane'], 0);
				}				
			}); // each
			
		} else {
						
			return this.each(function() {				
				var $this = $(this); // a polaroid
				
				$this.find('.face-container:eq(1)').hide();
				// $this.find('.face-container:eq(0)').hide();
				
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

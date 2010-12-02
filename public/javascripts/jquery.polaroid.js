(function($){
	
	$.fn.polaroid = function() {
		
		this.each(function() {
			var $polaroid = $(this);
			$('a.close', $polaroid).click(function(event) {
				event.preventDefault();
				$polaroid.fadeOut();
			});
		});
		
		if ($.browser.safari) {

			return this.each(function() {
				$this = $(this); // a polaroid
				$this.find('.back.face')
					.css('-webkit-transform', 'rotateY(180deg)')

					.find('.scrollable')
						.scrollable({
							items: 'items',
							keyboard: false,
							next: '',
							prev: '',
							onSeek: function(event, idx) {
								if (idx == 1) {
									// Load the Photo Grid pane
									var $photoGrid = $(this.getRoot()).find('.photo-grid');
									var id = $photoGrid.closest('.polaroid').attr('data-profile_id');
									$photoGrid.load('/waves/profiles/' + id + '/photos');
								}
							}
						}).navigator()						
					.end()
					
					.find('.buddy-bar a.flip')
						.click(function(event) {
							event.preventDefault();	
							$(this).closest('.polaroid').toggleClass('flipped')
							// .find('.gripper').hide();
						})
					.end()										
				.end()
				
				.find('.front.face .buddy-bar a.flip')
					.click(function(event) {
						event.preventDefault();	
				
						var idx = $(this).closest('li').index();
						var $polaroid = $(this).closest('.polaroid')
						var $backFace = $polaroid.find('.back.face');
				
						// Manually scroll to correct pane.
						// Have to secretly undo the rotate
						// to do the scroll.							
						$backFace.css('-webkit-transform', 'rotateY(0deg)');
						$backFace.find('.scrollable').scrollable().seekTo(idx, 0);
						$backFace.css('-webkit-transform', 'rotateY(180deg)');
						
						// Hide the gripper
						// $(this).addClass('current')
							//.closest('.polaroid')
							// .find('.gripper').hide();
							
						// Do the flip
						$polaroid.toggleClass('flipped');
					})
				.end();
						
			}); // each
			
		} else {
			
			// Non-Safari
						
			return this.each(function() {
				$this = $(this); // a polaroid
				
				$this.find('.face-container:eq(1)').hide();
				$this.find('.front .buddy-bar a.flip').live('click', function(event) {
		    		event.preventDefault();
					
					var $polaroid = $(this).closest('.polaroid');
					$polaroid.data('scrollable-index', $(this).closest('li').index());
					
		    		$polaroid.flip({
						speed: 280,
		      			direction: 'lr',
		      			color: '#FFF',
		      			content: $polaroid.find('.face-container:hidden'),		
		      			onEnd: function() {
					  		$polaroid.find('.buddy-bar a.flip').click(function(event) {
								event.preventDefault();
								$polaroid.revertFlip();
								
							});

							// Make polaroids work
							$('a.message', $polaroid).postcard();

							// Make scrollable work
							$polaroid.find('.scrollable').scrollable({
								items: 'items',
								keyboard: false,
								next: '',
								prev: '',							
	      	    				onSeek: function(event, idx) {
	      	      					if (idx == 1) {
	      	        					// Photo Grid
	      	        					var $photoGrid = $(this.getRoot()).find('.photo-grid');
	      	        					var id = $photoGrid.closest('.polaroid').attr('data-id');
	                					$photoGrid.load('/waves/profiles/' + id + '/photos');
									} // if
	      	    				} // onSeek
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


(function($){
	
	$.fn.polaroid = function(options) {

		var settings = {
			'close-button' : false
		}

		function clickToPostcard(polaroid) {
			$(polaroid).find('a.conversation').click(function(event) {
				event.preventDefault();
				$('<div class="floating"></div>')
					.appendTo('.floating-container')
					.load($(this).attr('href'), function() {
						$(this).find('.postcard')
							.postcard()
							.draggable({
								cancel: '.thread, textarea, button',
								zIndex: 9999,
								stack: '.floating'
							})
							.position({
								my: 'left center',
								of: event,
								offset: '30 0',
								collision: 'fit'
							})
							.find('textarea').focus();					
					});
			});			
		}
		
		$.extend(settings, options);		
				
		if ($.browser.safari) {

			return this.each(function() {
							
				$this = $(this); // a polaroid

				if (settings[ 'close-button' ] === true) {
					$('a.close', $this).click(function(event) {
						$(event.target).closest('.floating')
							.fadeOut(function() {
								$(this).remove();
							});
						return false;
					});
				}
				
				clickToPostcard(this);
				
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
									$photoGrid.load('/wave/profiles/' + id + '/photos');
								}
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
				
						// Manually scroll to correct pane.
						// Have to secretly undo the rotate
						// to do the scroll.							
						$backFace.css('-webkit-transform', 'rotateY(0deg)');
						$backFace.find('.scrollable').scrollable().seekTo(idx, 0);
						$backFace.css('-webkit-transform', 'rotateY(180deg)');
							
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
				
				if (settings[ 'close-button' ] === true) {
					$('a.close', $this).live('click', function(event) {
						$this.fadeOut();
						$(event.target).closest('.floating').remove();
						return false;
					});
				}				

				clickToPostcard(this);
				
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
							clickToPostcard($polaroid);
							$polaroid.find('.scrollable').scrollable({
								items: 'items',
								keyboard: false,
								next: '',
								prev: '',							
	      	    				onSeek: function(event, idx) {
	      	      					if (idx == 1) {
	      	        					// Photo Grid
	      	        					var $photoGrid = $(this.getRoot()).find('.photo-grid');
	      	        					var id = $photoGrid.closest('.polaroid').attr('data-profile_id');
	                					$photoGrid.load('/wave/profiles/' + id + '/photos');
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


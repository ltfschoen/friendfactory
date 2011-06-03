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
			// no-csstransforms3d
			return this.each(function() {
				var $this = $(this), // a polaroid				
					scrollableSettings = {
						items: 'items',
						keyboard: false,
						next: '',
						prev: '',							
	   	    			onSeek: function(event, idx) {
							panes.init(this, idx);
	   	    			}						
					};				
								
				if (settings['close-button'] === true) {
					$('a.close', $this).live('click', function(event) {
						$this.fadeOut();
						$(event.target).closest('.floating').remove();
						return false;
					});
				}				

				if (settings['pane'] === undefined) {
					$this
						.find('.face-container:eq(1)')
							.hide()
						.end()
						.find('.face-container:eq(0) .buddy-bar a.flip')
							.live('click', function(event) {
								var $polaroid = $(this).closest('.polaroid');
					    		event.preventDefault();
								$polaroid
									.data('scrollable-index', $(this).closest('li').index())
									.flip({
										speed: 300,
						      			direction: 'lr',
						      			color: '#FFF',
						      			content: $polaroid.find('.face-container:hidden'),				
						      			onEnd: function() {
									  		$polaroid
												.find('.buddy-bar a.flip')
													.click(function(event) {
														event.preventDefault();
														$polaroid.revertFlip();								
													});

											// Make links work on backside												
											$polaroid.find('.scrollable')
												.scrollable(scrollableSettings)
												.navigator();

											var idx = $polaroid.data('scrollable-index');
											$polaroid.find('.scrollable').scrollable().seekTo(idx, 0);
						      			} // onEnd		
						    		}); // flip		
					  		}); // live

				} else {
					var flippery = function(event) {
							var $polaroid = $(event.target).closest('.polaroid');	
							event.preventDefault();
							$polaroid
								.flip({
									speed: 300,
					      			direction: 'lr',
					      			color: '#FFF',
					      			content: $polaroid.find('.face-container:hidden'),
									onEnd: function() {
										$polaroid
											.find('.front.face:not(:hidden) .buddy-bar a.flip')
												.bind('click', function(event) {
													event.preventDefault();
													$polaroid
														.data('scrollable-index', $(event.target).closest('li').index())																										
														.revertFlip();
												})
											.end()
								
											.find('.back.face:not(:hidden)')
											 	.find('.buddy-bar a.flip')
													.bind('click', flippery)
												.end()
												.find('.scrollable')
													.scrollable(scrollableSettings)
													.navigator();
										
										if ($polaroid.find('.back.face').length == 1) {
											var idx = $polaroid.data('scrollable-index');
											$polaroid.find('.scrollable').scrollable().seekTo(idx ,0);											
										}
									} // onEnd
								});
						};
					
					$this
						.find('.face-container:eq(0)')
							.hide()
						.end()						
						.find('.face-container:eq(1)')
							.find('.buddy-bar a.flip')
								.click(flippery)
							.end()						
							.find('.scrollable')
								.scrollable(scrollableSettings)
								.navigator();
						
					$this.find('.scrollable').scrollable().seekTo(settings['pane'], 0);
					
				} // if		
			}); // each			
		} // if		
	}; // fn.polaroid
	
})(jQuery);

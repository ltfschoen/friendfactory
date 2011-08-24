(function($) {

	$.fn.polaroid = function(options) {
		var settings = {
				'close-button' : false,
				'set-focus' : true
			},

			panes = {
				init: function(scrollable, idx, setFocus) {
					var panes = this,
						$pane = $(scrollable.getRoot()).find('.pane:eq(' + idx + ')'),
						paneName = $pane.data('pane'),
						profileId = $pane.closest('.polaroid').attr('data-profile_id');
					
					$pane.load('/wave/profiles/' + profileId + '/' + paneName, function(event) {
						if (panes[paneName] !== undefined) {
							panes[paneName]($pane, setFocus);
						}						
					});					
				},

				tearDown: function(scrollable, idx) {
					var $pane = $(scrollable.getRoot()).find('.pane.conversation');
					$pane.find('.message-input').hide();
				},

				conversation: function($pane, setFocus) {
					$pane.find('.wave_conversation').chat();					
					if (setFocus === true) {						
						$pane.find('textarea').focus();						
					}
				}
			}

		$.extend(settings, options);

		if (Modernizr.csstransforms3d && !jQuery.browser.chrome) {
			return this.each(function() {
				var $this = $(this), // a polaroid
					$backFace = $this.find('.back.face'),
					transitionDuration = $this.css('-webkit-transition-duration'),
					setFocus = settings['set-focus'];

				if (settings['pane'] === undefined) {
					$this.css({ '-webkit-transition-duration': '0s' }).addClass('flipped');
					$backFace.find('.content').css({ opacity: 0.0 });
				}

				if (settings['close-button'] === true) {
					$('a.close', $this).click(function(event) {
						$(event.target).closest('.wave_profile')
							.fadeOut(function() {
								var $this = $(this),
									$floating = $(this).closest('.floating'),
									paneIdx = $backFace.find('.scrollable').scrollable().getIndex();									
								$this.remove();
								$floating.remove();
								
								if (paneIdx === 3) {
									var conversationId = $backFace.find('.wave_conversation').data('id');
									$.ajax({
										url: '/wave/conversations/' + conversationId + '/close',
										data: [],
										dataType: 'script',
										type: 'PUT'
									});
								}
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
							onBeforeSeek: function(event, idx) {
								panes.tearDown(this, idx);
							},
							onSeek: function(event, idx) {
								panes.init(this, idx, setFocus);
							}
						}).navigator()
					.end()

					.find('.buddy-bar a.flip')
						.click(function(event) {
							event.preventDefault();							
							$backFace.find('.content').fadeTo('fast', 0.0, function(){
								$this.css({ '-webkit-transition-duration': transitionDuration }).toggleClass('flipped');
							});
							// $this.css({ '-webkit-transition-duration': transitionDuration }).toggleClass('flipped');
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
					setFocus = true;
				}
			}); // each
			
		} else {
			// no-csstransforms3d
			return this.each(function() {
				var $this = $(this), // a polaroid
					setFocus = settings['set-focus'],							
					scrollableSettings = {
						items: 'items',
						keyboard: false,
						next: '',
						prev: '',
						onBeforeSeek: function(event, idx) {
							panes.tearDown(this, idx);
						},									
	   	    			onSeek: function(event, idx) {
							panes.init(this, idx, setFocus);
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
					setFocus = true;					
				} // if
			}); // each						
		} // if		
	}; // fn.polaroid
	
})(jQuery);

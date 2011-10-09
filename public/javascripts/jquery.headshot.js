(function($) {
	var
		panes = {
			init: function(paneName, setFocus) {
				// var $pane = $(scrollable.getRoot()).find('.pane:eq(' + idx + ')');
				// loadPane($pane, setFocus);
				var $pane = $(paneName, '.face')
				alert($pane);
			},

			tearDown: function(paneName) {
				// var $pane = $(scrollable.getRoot()).find('.pane.conversation');
				// $pane.find('.message-input').hide();
			},

			conversation: function(pane, setFocus) {
				// $(pane).find('.wave_conversation').chat();
				// if (setFocus === true) {
				// 	$pane.find('textarea').focus();
				// }
			},
		
			pokes: function($pane) {
				// $pane.find('a.profile').bind('click', function(event) {
				// 	event.preventDefault();
				// 	$('<div class="floating"></div>')
				// 		.appendTo('.floating-container')
				// 		.load($(this).attr('href'), function() {	 			
				// 			$(this).position({
				// 				my: 'left center',
				// 				of: event,
				// 				offset: '30 0',
				// 				collision: 'fit'
				// 			})	
				// 		.draggable()
				// 		.find('div.polaroid')
				// 			.polaroid({ 'close-button' : true });
				// 	});
				// });
			}
		},

		loadPane = function(pane, setFocus) {
			var $pane = $(pane),
				paneName = $pane.data('pane'),
				profileId = $pane.closest('.polaroid').attr('data-profile_id');

			$pane.load('/wave/profiles/' + profileId + '/' + paneName, function(event) {
				if (panes[paneName] !== undefined) {
					panes[paneName]($pane, setFocus || false);
				}
			});
		},
		
		seekTo = function(paneName) {
			
		},
		
		flipTransforms3d = function(headshot) {
			var $this = $(headshot),
				$frontFace = $this.find('.front.face'),
				$backFace = $this.find('.back.face');
		
			$frontFace.click(function() {
				$this.toggleClass('flipped');
				return false;
			});

			$backFace.click(function() {
				$this.toggleClass('flipped');
				return false;
			});			
		},
		
		flipNoTransforms3d = function(headshot) {
			var $headshot = $(headshot);
			$headshot
				.find('.face-container:eq(1)').hide().end()
				.find('.face-container:eq(0) a.flip')
					.click(function(event) {
						event.preventDefault();
						$headshot
							.data('seek-to', $(this).text())
							.flip({
								speed: 300,
				      			direction: 'rl',
				      			color: '#FFF',
				      			content: $headshot.find('.face-container:hidden'),
								onEnd: function () {
									if ($headshot.find('.back.face').length == 1) {
										var panelName = $headshot.data('seek-to');
										// alert(panelName);
										panes['init'](panelName);
									}															
									$headshot.find('a.flip')
										.click(function(event) {
											// alert($(this).text());
											$headshot
												.data('seek-to', $(this).text())
												.revertFlip();
											return false;
										});
								}
							});
					});
		};
	

	$.fn.headshot = function(options) {
		return this.each(function() {
			if (Modernizr.csstransforms3d) {
				flipTransforms3d(this);
			} else {
				flipNoTransforms3d(this);
			}
		});
	};
	
})(jQuery);

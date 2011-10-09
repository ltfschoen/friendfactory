(function($) {
	var
		panes = {
			init: function($headshot, paneName, url, setFocus) {
				var $content = $headshot.find('.content'),
					$pane = $content.find('.pane');
				
				$pane.css({ 'visibility': 'visible', 'opacity': 0.0 });
				$pane.load(url, function() {
					if (panes[paneName] !== undefined) {
						panes[paneName]($pane, setFocus);
					}
					$pane.fadeTo('fast', 1.0);
				});
			}
			
			// pokes: function($headshot, url) {
			// 	$headshot.find('.pane.pokes').load(url);
			// 	// $headshot.find('.pane.pokes').html('pokes');
			// 	
			// 	// $pane.find('a.profile').bind('click', function(event) {
			// 	// 	event.preventDefault();
			// 	// 	$('<div class="floating"></div>')
			// 	// 		.appendTo('.floating-container')
			// 	// 		.load($(this).attr('href'), function() {	 			
			// 	// 			$(this).position({
			// 	// 				my: 'left center',
			// 	// 				of: event,
			// 	// 				offset: '30 0',
			// 	// 				collision: 'fit'
			// 	// 			})	
			// 	// 		.draggable()
			// 	// 		.find('div.polaroid')
			// 	// 			.polaroid({ 'close-button' : true });
			// 	// 	});
			// 	// });
			// },

			// conversation: function($headshot, url, setFocus) {
			// 	var $pane = $headshot.find('.pane.conversation');
			// 	$pane.load(url, function(text, status) {
			// 		if (status === 'success') {
			// 			$pane.find('.wave_conversation').chat();
			// 			if (setFocus === true) $pane.find('textarea').focus();
			// 		}
			// 	});
			// }
		},

		flipTransforms3d = function(headshot) {
			var $headshot = $(headshot),
				$frontFace = $headshot.find('.front.face'),
				$backFace = $headshot.find('.back.face'),
				$content = $backFace.find('.content');

			if (jQuery.browser.chrome === true) $content.hide();

			$headshot.bind('webkitTransitionEnd', function() {
				if ($headshot.hasClass('flipped')) {
					var paneName = $headshot.data('pane-name'),
						url = $headshot.data('url');

					if (jQuery.browser.chrome === true) $content.show();
					panes['init']($headshot, paneName, url);					
				}
			});

			$frontFace
				.find('a.flip')
					.click(function() {
						var $this = $(this),
							paneName = $this.data('pane-name'),
							url = $this.attr('href');

						if (jQuery.browser.chrome === true) $content.hide();
						$content.find('.pane').css({ 'visibility': 'hidden' });
						$headshot
							.data('pane-name', paneName)
							.data('url', url)
							.toggleClass('flipped');							
						return false;
					});

			$backFace
				.find('a.flip')
					.click(function() {			
						if (jQuery.browser.chrome === true) $content.hide();						
						$headshot.toggleClass('flipped');
						return false;
					})
				.end()

				.find('a.swipe')
					.click(function(event) {
						var paneName = $(this).data('pane-name'),
							url = $(this).attr('href');

						event.preventDefault();
						panes['init']($headshot, paneName, url);
					});
		},

		flipNoTransforms3d = function(headshot) {
			var $headshot = $(headshot);
			$headshot
				.find('.face-container:eq(1)').hide().end()				
				.find('.face-container:eq(0) a.flip')				
					.click(function(event) {
						var paneName = $(this).text(),
							url = $(this).attr('href');
						// alert('once');
						
						$headshot
							.flip({
								speed: 300,
				      			direction: 'rl',
				      			color: '#FFF',
				      			content: $headshot.find('.face-container:hidden'),
								onEnd: function () {
									alert('onEnd');
									// if ($headshot.find('.back.face').length == 1) {
									// 	panes['init']($headshot, paneName, url);
									// }
									// alert(paneName)
									if (panes[paneName] !== undefined ) panes[paneName](url);
									
									$headshot.find('a.flip')
										.click(function(event) {
											// alert('twice');
											paneName = $(this).text();
											url = $(this).attr('href');												
											$headshot.revertFlip();
											return false;
										});
								}
							});
						return false;							
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

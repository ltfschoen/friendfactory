(function($) {
	var
		panes = {
			init: function ($headshot, paneName, url, setFocus, options) {
				var $content = $headshot.find('.content'),
					$pane = $content.find('.pane'),
					settings = {
						onBefore: function () {},
						onEnd: function () {}
					};

				$.extend(settings, options);
				
				settings['onBefore']($pane);
				$pane
					.removeClass()
					.addClass('pane ' + paneName)
					.load(url, function() {
						if (panes[paneName] !== undefined) {
							panes[paneName]($pane, setFocus);
						}
						settings['onEnd']($pane);
					});
			},

			// pokes: function($pane, setFocus) {
			// 	$pane.find('a.profile').bind('click', function(event) {
			// 		event.preventDefault();
			// 		$('<div class="floating"></div>')
			// 			.appendTo('.floating-container')
			// 			.load($(this).attr('href'), function() {
			// 				$(this).position({
			// 					my: 'left center',
			// 					of: event,
			// 					offset: '30 0',
			// 					collision: 'fit'
			// 				})	
			// 			.draggable()
			// 			.find('div.polaroid')
			// 				.polaroid({ 'close-button' : true });
			// 		});
			// 	});
			// },

			conversation: function($pane, setFocus) {
				$pane.find('.wave_conversation').chat();
				if (setFocus === true) $pane.find('textarea').focus();
			}
		};
		
	$.fn.flipTransforms3d  = function () {
		return this.each(function() {
			var $headshot = $(this),
				$frontFace = $headshot.find('.front.face'),
				$backFace = $headshot.find('.back.face'),
				$content = $backFace.find('.content');

			if (jQuery.browser.chrome === true) $content.hide();

			$headshot.bind('webkitTransitionEnd', function() {
				if ($headshot.hasClass('flipped')) {
					var paneName = $headshot.data('pane-name'),
						url = $headshot.data('url');

					panes['init']($headshot, paneName, url, true, {
						onBefore: function ($pane) {
							if (jQuery.browser.chrome === true) $content.show();
							$pane.css({ visibility: 'visible', opacity: 0.0 })
						},
						onEnd: function ($pane) {
							$pane.fadeTo('fast', 1.0);
						}
					});
				}
			});

			$frontFace
				.find('a.flip')
					.click(function() {
						var $this = $(this),
							paneName = $this.data('pane-name'),
							url = $this.attr('href');

						if (jQuery.browser.chrome === true) $content.hide();

						$content.find('.pane')
							.css({ 'visibility': 'hidden' });

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
					.click(function() {
						var paneName = $(this).data('pane-name'),
							url = $(this).attr('href');

						panes['init']($headshot, paneName, url, false, {
							onBefore: function ($pane) {
								$pane.css({ visibility: 'hidden' });
							},
							onEnd: function ($pane) {
								$pane.css({ visibility: 'visible' });
							}							
						});
						return false;
					});
		});
	};

	$.fn.flipNoTransforms3d = function () {
		return this.each(function() {
			var $headshot = $(this),
				$frontFace = $headshot.find('.front.face'),
				$backFace = $headshot.find('.back.face'),
				$content = $backFace.find('.content'),
			
				initBackFace = function (paneName, url) {
					panes['init']($headshot, paneName, url, true);
				},
			
				initFrontFace = function () {},
							
				flipper = function () {
					if ($headshot.hasClass('flipped')) {
						initBackFace(paneName, url);
					} else {
						initFrontFace();
					}
				},

				flipSettings = {
					speed: 300,
			      	direction: 'lr',
			      	color: '#FFF',
					onEnd: flipper
				};

			$headshot.find('.face-container:eq(1)').hide();

			$frontFace
				.find('a.flip')
					.live('click', function(event) {
						var	$this = $(this)
							paneName = $this.data('pane-name'),
							url = $this.attr('href'),
							$content = $headshot.find('.face-container:hidden');

						$headshot
							.addClass('flipped')
							.flip($.extend(flipSettings, { content: $content }));
						return false;
					});

			$backFace
				.find('a.flip')
					.live('click', function() {
						$headshot
							.removeClass('flipped')
							.revertFlip();
						return false;
					})
				.end()

				.find('a.swipe')
					.live('click', function() {
						var paneName = $(this).data('pane-name'),
							url = $(this).attr('href');

						panes['init']($headshot, paneName, url, false, {
							onBefore: function ($pane) {
								$pane.css({ visibility: 'hidden' });
							},
							onEnd: function ($pane) {
								$pane.css({ visibility: 'visible' });
							}
						});
						return false;
					});
		});
	};

	$.fn.headshot = function() {
		return this.each(function() {
			if (Modernizr.csstransforms3d) {
				$(this).flipTransforms3d();
			} else {
				$(this).flipNoTransforms3d();
			}
		});
	};

})(jQuery);

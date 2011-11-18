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

			conversation: function($pane, setFocus) {
				$pane.find('.wave_conversation').chat();
				if (setFocus === true) $pane.find('textarea').focus();
			}
		},

		pokeable = function (data, status) {
			var $this = $(this),
				$pane = $this.closest('.pane'),
				$headshot = $pane.closest('.headshot'),
				url = $headshot.find('a.pokes').attr('href');

			$this.hide();
			$pane.load(url, function() {
				$headshot.toggleClass('poked', status['poked']);
			});
		},

		swipeable = function () {
			var $this = $(this),
				$headshot = $this.closest('.headshot'),
				paneName = $this.data('pane-name'),
				url = $this.attr('href');

			panes['init']($headshot, paneName, url, false, {
				onBefore: function ($pane) {
					$pane.css({ visibility: 'hidden' });
				},
				onEnd: function ($pane) {
					$pane.css({ visibility: 'visible' });
				}
			});
			return false;
		},

		closeable = function () {
			$(this).closest('.floating').remove();
			return false;
		};

	$.fn.flipTransforms3d  = function () {
		return this.each(function() {
			var $headshot = $(this),
				$frontFace = $headshot.find('.front.face'),
				$backFace = $headshot.find('.back.face'),
				$content = $backFace.find('.content');

			if (jQuery.browser.chrome === true) {
				$content.hide();
			}

			$headshot.bind('webkitTransitionEnd', function() {
				if ($headshot.hasClass('flipped')) {
					// Back face init
					var paneName = $headshot.data('pane-name'),
						url = $headshot.data('url');

					panes['init']($headshot, paneName, url, $headshot[0].settings['setFocus'], {
						onBefore: function ($pane) {
							if (jQuery.browser.chrome === true) $content.show();
							$pane.css({ visibility: 'visible', opacity: 0.0 })
						},
						onEnd: function ($pane) {
							$pane.fadeTo('fast', 1.0);
						}
					});
				}
				
				if (this.onFlip !== undefined) this.onFlip(this);
			});

			$headshot
				.find('a.close')
					.click(closeable);

			$frontFace
				.find('a.flip')
					.click(function() {
						if ($headshot[0].beforeFlip()) {
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
						} else {
							return false;
						}
					});

			$backFace
				.find('a.flip')
					.click(function() {
						if (jQuery.browser.chrome === true) $content.hide();
						$headshot.toggleClass('flipped');
						return false;
					})
				.end()

				.find('a.poke')
					.live('ajax:success', pokeable)
				.end()

				.find('a.swipe').click(swipeable);
		});
	};

	$.fn.flipNoTransforms3d = function () {
		return this.each(function() {
			var $headshot = $(this),
				$frontFace = $headshot.find('.front.face'),
				$backFace = $headshot.find('.back.face'),
				$content = $backFace.find('.content'),
			
				initBackFace = function (paneName, url) {
					panes['init']($headshot, paneName, url, $headshot[0].settings['setFocus']);
				},

				initFrontFace = function () {},

				flipSettings = {
					speed: 300,
					direction: 'lr',
					color: '#FFF'
				};

			$headshot
				.find('.face-container:eq(1)')
					.hide()
				.end()
				.find('a.close')
					.live('click', closeable);

			$frontFace
				.find('a.flip')
					.live('click', function(event) {
						if ($headshot[0].beforeFlip()) {
							var	$this = $(this),
								paneName = $this.data('pane-name'),
								url = $this.attr('href'),
								$content = $headshot.find('.face-container:hidden'),

								flipper = function () {
									if ($headshot.hasClass('flipped')) {
										initBackFace(paneName, url);
									} else {
										initFrontFace();
									}
								
									if ($headshot[0].onFlip !== undefined) {
										$headshot[0].onFlip($headshot[0]);
									}
								};

							$headshot
								.addClass('flipped')
								.flip($.extend(flipSettings, { content: $content, onEnd: flipper }));
							return false;
						} else {
							return false;
						}
					});

			$backFace
				.find('a.flip')
					.live('click', function() {
						$headshot
							.removeClass('flipped')
							.find('.face').hide().end()
							.revertFlip();
						return false;
					})
				.end()

				.find('a.poke')
					.live('ajax:success', pokeable)
				.end()

				.find('a.swipe').live('click', swipeable);
		});
	};

	$.fn.headshot = function(options) {
		var settings = {
			beforeFlip: function() { return true; },
			onFlip: function() {},
			panes: panes,
			setFocus: true
		};

		$.extend(settings, options);
		$.extend(panes, settings['panes']);

		return this.each(function() {
			var $this = $(this);

			this.beforeFlip = settings['beforeFlip'];
			this.onFlip = settings['onFlip'];
			this.settings = { setFocus: settings['setFocus'] };

			if (Modernizr.csstransforms3d) {
				$this.flipTransforms3d();
			} else {
				$this.flipNoTransforms3d();
			}

			if (settings['pane'] !== undefined) {
				setTimeout(function() {
					$this.find('.front.face a[data-pane-name="' + settings['pane'] + '"]')
						.trigger('click');
				}, 1200);
			}
		});
	};

})(jQuery);

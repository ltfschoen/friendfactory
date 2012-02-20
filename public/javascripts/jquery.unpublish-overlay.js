(function ($) {

	var
		defaultOverLayConfig = {
			top: '40%',
			left: 'center',
			closeOnClick: true,
			closeOnEsc: true,
			load: false,
			speed: 150,
			closeSpeed: 300,
			effect: 'evaporate',
			mask: { color: '#000', opacity: 0.5 },
			onClose: function (event) {
				var url = this.getTrigger().attr('href'),
					originalTarget = (event.originalTarget || event.srcElement || event.originalEvent.target),
					ok = (originalTarget && $(originalTarget).hasClass('ok')) || false;
				// if (ok) { $.ajax({ type: 'delete', url: url, dataType: 'script' }); }
				if (ok) { this.getConf().onOK(this); }
			}
		},

		extendDefaultOverlayOptionsWith = function(opts) {
			return $.extend({}, defaultOverLayConfig, opts);
		};

	$.tools.overlay.addEffect('evaporate',
		function (position, callback) {
			var config = this.getConf(),
				speed = config.speed,
				$window = $(window);

			config.fixed || (position.top += $window.scrollTop(), position.left += $window.scrollLeft()),
			position.position = config.fixed ? "fixed" : "absolute",
			this.getOverlay().css(position).css({ opacity: 0, display: 'block' }).animate({ marginTop: -50, opacity: 1 }, speed, 'linear', callback);
		},

		function (callback) {
			var overlay = this.getOverlay(),
				config = this.getConf(),
				speed = config.closeSpeed;

			this.getOverlay().animate({ marginTop: -400, opacity: 0 }, speed, 'linear', function () {
				overlay.css({ opacity: 0, marginTop: 0});
				callback.call();
			});
		}
	);

	$.fn.unpublishOverlay = function () {
		return this.each(function() {
			$(this).overlay(extendDefaultOverlayOptionsWith({
				onOK: function (overlay) {
					var url = overlay.getTrigger().attr('href');
					$.ajax({ type: 'delete', url: url, dataType: 'script' });
				}
			}));
		});
	};

	$.fn.disablePersonageOverlay = function () {
		return this.each(function() {
			$(this).overlay(extendDefaultOverlayOptionsWith({
				onOK: function (overlay) {
					alert('here');
				}
			}));
		});
	};

	$.fn.deleteProfileOverlay = function () {
		return this.each(function() {
			$(this).overlay(extendDefaultOverlayOptionsWith({
				onOK: function (overlay) {
				}
			}));
		});
	};

})(jQuery);

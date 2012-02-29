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

			onOK: function (event) {
				return true;
			},

			onCancel: function (event) {
				return false;
			},

			onClose: function (event) {
				var config = this.getConf(),
					originalTarget = (event.originalTarget || event.srcElement || event.originalEvent.target),
					ok = (originalTarget && $(originalTarget).hasClass('ok')) || false;
				ok ? config.onOK(this) : config.onCancel(this);
			}
		},
		
		overlayWithoutEvaporation = $.fn.overlay,
		
		overlayWithEvaporation = function (opts) {
			return overlayWithoutEvaporation.call(this, $.extend({}, defaultOverLayConfig, opts));
		};
		
	$.fn.overlay = overlayWithEvaporation;

	$.tools.overlay.addEffect('evaporate',
		function (position, callback) {
			var config = this.getConf(),
				speed = config.speed,
				$window = $(window);

			config.fixed || (position.top += $window.scrollTop(), position.left += $window.scrollLeft()),
			position.position = config.fixed ? "fixed" : "absolute",
			this.getOverlay()
				.css(position)
				.css({ marginTop: 0, opacity: 0, display: 'block' })
				.animate({ marginTop: -50, opacity: 1 }, speed, 'linear', callback);
		},

		function (callback) {
			var overlay = this.getOverlay(),
				config = this.getConf(),
				speed = config.closeSpeed;

			this.getOverlay().animate({ marginTop: -400, opacity: 0 }, speed, 'linear', function () {
				overlay.css({ display: 'none' });
				callback.call();
			});
		}
	);

	$.fn.unpublishOverlay = function () {
		return this.each(function() {
			$(this).overlay({
				onOK: function (overlay) {
					var url = overlay.getTrigger().attr('href');
					$.ajax({ type: 'delete', url: url, dataType: 'script' });
				}
			});
		});
	};

})(jQuery);

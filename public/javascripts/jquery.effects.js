(function($) {

	$.fn.bounceable = function() {

		return $(this).bind('bounce', function() {
			var $this = $(this);

			if (false && Modernizr.cssanimations) {
				// Temporarily disabled because of poor Safari rendering
				$this.bind('webkitAnimationEnd', function(event) {
					$this.removeClass('bounce');
				}).addClass('bounce');

			} else {
				$this.animate({ top: -15 }, 600)
					.delay(100)
					.animate({ top: 30 }, 100)
					.animate({ top: 0 }, 500);
			}
		});
		return $this;
	};

	$.fn.shakeable = function () {
		return $(this).bind('shake', function() {
			var $this = $(this);
			
			if (Modernizr.cssanimations) {
				$this.bind('webkitAnimationEnd', function(event) {
					$this.removeClass('shake');
				})
				.addClass('shake');
			} else {
				$this.animate({ left: -3 }, 50)
					.animate({ left: 3 }, 50)
					.animate({ left: 0 }, 50);
			}
		});
	};

	$.fn.pulse = function () {
		var $this = $(this),
			worker;

		if (Modernizr.cssanimations) {
			return $this.toggleClass('pulse');
		}
		
		if ($this.hasClass('pulse')) {
			var worker = setInterval(function() {
				$this.fadeTo(300, 0.5).fadeTo(300, 1.0);
			}, 600);
			$this.attr('data-worker', worker);
							
		} else {
			clearInterval($this.attr('data-worker'));
			$this.removeAttr('data-worker');
		}

		return $this;
	};
	
})(jQuery);

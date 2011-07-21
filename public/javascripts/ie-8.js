(function($) {

	var aliasedFadeTo = $.fn.fadeTo;

	$.fn.fadeTo = function() {
		if ($.browser.msie) {
			var $this = $(this),
				speed = arguments[0],
				opacity = arguments[1],
				callBack;				

			$(this).css({ opacity: 'auto' });

			if ($.isFunction(arguments[arguments.length - 1])) {
				callBack = arguments[arguments.length - 1];
			}

			if (opacity === 0) $this.css('visibility', 'hidden');
			if (callBack !== undefined) callBack();
			if (opacity === 1) $this.css('visibility', 'visible');
			return $this;

		} else {
			return aliasedFadeTo.apply(this, arguments);
		}
	};

	var aliasedHide = $.fn.hide;

	$.fn.hide = function() {
		if ($.browser.msie) {
			var $this = $(this),
				callBack;

			$(this).css({ opacity: 'auto' });

			if ((arguments.length > 0) && $.isFunction(arguments[arguments.length - 1])) {
				callBack = arguments[arguments.length - 1];
			}

			if (callBack !== undefined) {
				aliasedHide.apply(this);
				callBack.apply(this);
				return this;
			} else {
				return aliasedHide.apply(this);
			}

		} else {
			return aliasedHide.apply(this, arguments);
		}
	};

})(jQuery);

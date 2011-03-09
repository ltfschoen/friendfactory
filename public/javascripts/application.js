if (/chrome/.test(navigator.userAgent.toLowerCase())) {
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}


(function($) {

	$.fn.buttonize = function(customOptions) {
		var options = $.extend({}, $.fn.buttonize.defaults, customOptions || {});
		return $(this)
			.find('button[type="submit"]')
				.button({ icons: { primary: 'ui-icon-check' }, text: options.text })
			.end()

			.find('button.cancel')
				.button({ icons: { primary: 'ui-icon-close' }, text: options.text })
			.end();
	};	

	$.fn.buttonize.defaults = {
		text: false
	};


	var aliasedFadeTo = $.fn.fadeTo;
	
	$.fn.fadeTo = function() {
		if ($.browser.msie) {
			var $this = $(this).css({ opacity: 'auto' }),
				opacity = arguments[1],
				callBack;
			
			if ($.isFunction(arguments[arguments.length - 1])) {
				callBack = arguments[arguments.length - 1];
			}						
			
			return (opacity === 0) ? $this.hide(0, callBack) : $this.show(0, callBack);
			
		} else {
			return aliasedFadeTo.apply(this, arguments);			
		}
	};

	
	var aliasedHide = $.fn.hide;
	
	$.fn.hide = function() {
		if ($.browser.msie) {
			var $this = $(this).css({ opacity: 'auto' }),
				callBack;

			if ((arguments.length > 0) && $.isFunction(arguments[arguments.length - 1])) {
				callBack = arguments[arguments.length - 1];
			}

			if (callBack !== 'undefined') {
				aliasedHide.apply(this);
				return callBack.apply(this);
			} else {
				return aliasedHide.apply(this);				
			}

		} else {
			return aliasedHide.apply(this, arguments);			
		}
	};

})(jQuery);

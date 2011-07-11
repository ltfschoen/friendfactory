if (/chrome/.test(navigator.userAgent.toLowerCase())) {
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}

(function($) {
	var aliasedFadeTo = $.fn.fadeTo;
	
	$.fn.fadeTo = function() {
		if ($.browser.msie) {
			var $this = $(this).css({ opacity: 'auto' }),
				speed = arguments[0],
				opacity = arguments[1],
				callBack;				
			
			if ($.isFunction(arguments[arguments.length - 1])) {
				callBack = arguments[arguments.length - 1];
			}

			// return (opacity === 0) ? $this.hide(0, callBack) : $this.show(0, callBack);
			if (opacity === 0) $this.css('visibility', 'hidden');
			if (callBack !== undefined) callBack();
			if (opacity === 1) $this.css('visibility', 'visible');
			
		} else {
			return aliasedFadeTo.apply(this, arguments);			
		}
	};
	
	// var aliasedHide = $.fn.hide;
	
	// $.fn.hide = function() {
	// 	if ($.browser.msie) {
	// 		var $this = $(this),
	// 			callBack;
	// 		
	// 		$(this).css({ opacity: 'auto' });
	// 
	// 		if ((arguments.length > 0) && $.isFunction(arguments[arguments.length - 1])) {
	// 			callBack = arguments[arguments.length - 1];
	// 		}
	// 
	// 		if (callBack !== undefined) {
	// 			aliasedHide.apply(this);
	// 			callBack.apply(this);
	// 			return this;
	// 		} else {
	// 			return aliasedHide.apply(this);				
	// 		}
	// 
	// 	} else {
	// 		return aliasedHide.apply(this, arguments);
	// 	}
	// };

})(jQuery);

jQuery(function($) {

	$('.posting-container').live('init', function(event) {
		if (event.target === this) {
			$('.posting', this).trigger('init');
		}
	});

	$('form').live('reset', function(event) {
		$('textarea, input', this).placehold();
	});

});

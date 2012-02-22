(function($) {

	$.fn.buttonize = function(customOptions) {
		var $this = $(this),
			options = $.extend({}, $.fn.buttonize.defaults, customOptions || {});
			
		$this
			.find('button[type="submit"], a.button.submit')
				.button({ icons: { primary: 'ui-icon-check' }, text: options.text })
			.end()
			
			.find('button.cancel, a.button.cancel')
				.button({ icons: { primary: 'ui-icon-close' }, text: options.text })
			.end()
			
			.find('a.button.new')
				.button({ icons: { primary: 'ui-icon-document' }, text: options.text })
			.end()

			.find('a.button.edit')
				.button({ icons: { primary: 'ui-icon-pencil' }, text: options.text })
			.end();
		
		return $this;
	};

	$.fn.buttonize.defaults = {
		text: false
	};

})(jQuery);
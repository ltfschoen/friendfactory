(function ($) {

	$.posting = $.posting || {};

	$.posting.link = function (links) {
		links
			.filter('.' + $.getUserId())
			.find('section.description, a.title')
				.attr('contenteditable', true)

				.bind('blur', function (event) {
					var $this = $(this),
						$posting = $this.closest('.posting'),
						params = {};

					if ($this.is('[contenteditable]')) {
						params[$this.attr('class')] = $this.html();
						$.posting.ajax($posting, { resource_attributes: params });
					};
				})
	};

})(jQuery);

(function ($) {

	$.posting = $.posting || {};

	$.posting.link = function (links) {
		links
			.filter('.' + $.getUserId())
			.find('p.description, a.title')
				.attr('contenteditable', true)

				.bind('blur', function (event) {
					var $this = $(this),
						$posting = $this.closest('.posting_link'),
						params = {};

					if ($this.is('[contenteditable]')) {
						params[$this.attr('class')] = $this.html();
						$.ajax({
							type: 'put',
							url: '/postings/' + $posting.getId(),
							data: { posting: { resource_attributes: params }},
							dataType: 'json',
							success: function () {}
						});
					};
				})
	};

})(jQuery);

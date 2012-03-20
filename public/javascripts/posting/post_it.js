(function ($) {

	$.posting = $.posting || {};

	$.posting.postIt = function (postings) {
		postings
			.filter('.' + $.getUserId())
			.find('section')
				.attr('contenteditable', true)

				.bind('blur', function (event) {
					var $this = $(this),
						$posting = $this.closest('.posting'),
						params = {};

					if ($this.is('[contenteditable]')) {
						params[$this.attr('class')] = $this.html();
						$.ajax({
							type: 'put',
							url: '/postings/' + $posting.getId(),
							data: { posting: params },
							dataType: 'json',
							success: function () {}
						});
					};
				})
	};

})(jQuery);

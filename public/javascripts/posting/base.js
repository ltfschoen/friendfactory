(function ($) {

	function postingsByType (collection, postingType) {
		return collection.children(postingType).andSelf().filter(postingType);
	};

	$.fn.posting = function () {
		$.posting.link(postingsByType(this, '.posting_link'));
		$.posting.postIt(postingsByType(this, '.posting_post_it'));
		return this;
	};

	$.posting = $.posting || {};

	$.fn.contentEditable = function () {
		return this.each(function () {
			$(this)
				.attr('contenteditable', true)
				.bind('blur', function (event) {
					var $this = $(this),
						$posting = $this.closest('.posting'),
						params = {};

					if ($this.is('[contenteditable]')) {
						params[$this.attr('class')] = $this.html();
						$.posting.ajax($posting, params);
					};
				})
		});
	};

	$.posting.ajax = function ($posting, params) {
		$.ajax({
			type: 'put',
			url: '/postings/' + $posting.getId(),
			data: { posting: params },
			dataType: 'json',
			success: function () {}
		});
	};

})(jQuery);

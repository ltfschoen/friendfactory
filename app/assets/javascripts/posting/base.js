(function ($) {

	function postingsByType (collection, postingType) {
		return collection.children(postingType).andSelf().filter(postingType);
	};

	$.posting = $.posting || {};

	$.fn.posting = function () {
		var posting = $.posting;
		posting.link(postingsByType(this, '.posting_link'));
		posting.postIt(postingsByType(this, '.posting_post_it'));
		posting.text(postingsByType(this, '.posting_text'));
		return this;
	};

	$.fn.contentEditable = function (callBack) {
		return this.each(function () {
			$(this)
				.attr('contenteditable', true)
				.bind('blur', function (event) {
					var $this = $(this),
						$posting = $this.closest('.posting'),
						params = {};

					if ($this.is('[contenteditable]')) {
						params[$this.attr('class')] = $this.html();
						$.posting.ajax($posting, params, callBack);
					};
				})
		});
	};

	$.posting.ajax = function ($posting, params, callBack) {
		$.ajax({
			type: 'put',
			url: '/postings/' + $posting.getId(),
			data: { posting: params },
			dataType: 'json',
			success: function () {
				if (callBack !== undefined) {
					callBack.call($posting);
				}
			}
		});
	};

})(jQuery);

(function ($) {

	$.fn.posting = function () {
		$.posting.link(this.filter('.posting_link'));
		return this;
	};

})(jQuery);

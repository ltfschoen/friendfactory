(function ($) {

	$.fn.posting = function () {
		$.posting.link(this.children('.posting_link').andSelf().filter('.posting_link'));
		$.posting.postIt(this.children('.posting_post_it').andSelf().filter('.posting_post_it'));
		return this;
	};

	$.posting = $.posting || {};

	$.posting.ajax = function () {
	};

})(jQuery);

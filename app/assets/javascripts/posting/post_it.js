(function ($) {

	$.posting = $.posting || {};

	$.posting.postIt = function (postings) {
		postings.filter('.' + $.getUserId()).find('section').contentEditable();
	};

})(jQuery);

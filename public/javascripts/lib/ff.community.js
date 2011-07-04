(function($) {

	$.fn.community = function() {
		var $this = $(this);
		$('div.polaroid', $this).polaroid();
		$('a', 'div.posting_link').embedly();
		$('.posting_comment.editable', $this).comment();
		return $;
	}
	
})(jQuery);

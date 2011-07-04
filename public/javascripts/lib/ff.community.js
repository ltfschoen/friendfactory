(function($) {

	$.fn.community = function() {
		var $this = $(this);
		$('div.polaroid', $this).polaroid();
		$('.posting_comment.editable', $this).comment();
		return $;
	}
	
})(jQuery);

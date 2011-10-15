(function($) {

	$.fn.navCancel = function () {
		return this.each(function() {
			$(this).click(function(event) {
				var $form = $(this).closest('form.new_post_frame');
				event.preventDefault();
				$('li.current', 'ul.nav').removeClass('current');
				$form.fadeTo('fast', 0.0, function() {
					$form.slideUp(900, 'easeOutBounce');
					$form[0].reset();
				});
			});
		});
	};

})(jQuery);
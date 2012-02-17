(function($) {

	$.fn.navCancel = function () {
		return this.each(function () {
			$(this).click(function (event) {
				var $form = $(this).closest('form.new_post_frame');

				event.preventDefault();
				$('li.current', 'ul.nav').removeClass('current');
				$form.fadeTo('fast', 0.0, function () {
					$form[0].reset;
					// $form.trigger('reset');
					$('input[type="text"], textarea', $form).val('').trigger('blur.placeholder');
					$form.slideUp(900, 'easeOutBounce');
				});
			});
		});
	};

})(jQuery);


jQuery(function($) {

	$('form.new_post_frame')
		.hide()

		.find('input.cancel')
			.navCancel()
		.end()

		.bind('ajax:before', function () {
			$(this).find('.spinner').css({ visibility: 'visible' });
			return true;
		})

		.bind('ajax:success', function () {
			var $this = $(this);
			$this[0].reset;
			$('input[type="text"], textarea', $this).val('').trigger('blur.placeholder');
		})		

		.bind('ajax:complete', function () {
			$(this).find('.spinner').css({ visibility: 'hidden' });
			return true;
		});

	$('a[rel]', 'ul.nav')
		.bounceable()
		.shakeable()

		.click(function(event) {
			var $this = $(this),
				$newForm = $($this.attr('rel'));
				
			event.preventDefault();	
			if (!$this.closest('li').siblings('li').andSelf().hasClass('current')) {
				$this.trigger('bounce')
					.closest('li')
					.addClass('current');

				$newForm
					.css({ opacity: 0.0, visibility: 'hidden' })
					.delay(1200)
					.slideDown(function() {
						$newForm
							.css({ visibility: 'visible' })
							.fadeTo('fast', 1.0);
					});
			} else {
				$this.trigger('shake');
			}	
		});

});

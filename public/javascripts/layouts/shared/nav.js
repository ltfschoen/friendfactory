(function($) {

	$.navOK = function ($frame) {
	    var
			$nav = $('li.current', 'ul.nav'),
			$form = $($('a', $nav).attr('rel')),
			$firstPosting = $('.post_frame').filter(':first');

		$nav.removeClass('current');

		$form.fadeTo('fast', 0.0, function() {
			$form.slideUp('fast', 'linear', function () {
				$frame
					.css({ opacity: 0.0 })
					.hide()
					.insertBefore($firstPosting)
					.delay(600)
					.slideDown(function () {
						var
							$post = $frame.find('.post'),
							height = $post.height() + 20,
							limit = Math.floor(height/50);

						$frame
							.height(height)
							.data('limit', limit)
							.fadeTo('fast', 1.0)
							.find('a.remove[rel]').unpublishOverlay();
					});
			});
		});
	};

	$.fn.navCancel = function () {
		return this.each(function () {
			$(this).click(function (event) {
				var $form = $(this).closest('form.new_post_frame');

				event.preventDefault();
				$('li.current', 'ul.nav').removeClass('current');
				$form.fadeTo('fast', 0.0, function () {
					$form[0].reset();
					// $form.trigger('reset');
					$('input[type="text"], textarea', $form).val('').trigger('blur.placeholder');
					$form.slideUp(900, 'easeOutBounce');
				});
			});
		});
	};

	$.fn.hashify = function () {

		var convert = new Showdown('datetimes', 'abbreviations').convert;

		return this.each(function () {
			var $this = $(this),
				$preview = $this.closest('.new_post_frame').find('.preview .body'),
				id = $this.attr('id');

			$this
				.autoResize({ extraSpace: 10 })
				.bind('keyup', function () {
					$preview.html(convert(this.value));
				});

			Hashify.editor(id, false, function () {
				$preview.html(convert(this.value));
			});
		});
	};

})(jQuery);


jQuery(function($) {

	$('form.new_post_frame')
		.hide()

		.find('input[type="text"], textarea')
			.placeholder()
		.end()

		.find('textarea#posting_text_body')
			.hashify()
		.end()

		.find('input.cancel')
			.navCancel()
		.end()

		.bind('ajax:before', function () {
			$(this).find('.spinner').css({ visibility: 'visible' });
			return true;
		})

		.bind('ajax:success', function () {
			var $this = $(this);
			$this[0].reset();
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

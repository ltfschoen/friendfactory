(function($) {

	$.getMiniComments = function (frames, callback) {
		var url = '/postings/fetch.json',
			idMap = {},
			fetchables = {};

		$.each(frames, function() {
			var $this = $(this),
				$post = $this.find('.post'),
				$reaction = $this.find('.reaction'),
				postId = $post.getId(),
				limit = $this.data('limit');

			if (postId !== undefined) {
				fetchables[postId] = limit;
				idMap[postId] = $post.attr('id');
				$reaction.html('');
			}
		});

		$.getJSON(url, { id: fetchables }, function(data) {
			$.each(data, function() {
				var domId = idMap[this.id],
					$reaction,
					html;

				if ((this.comments.length > 0) && (domId !== undefined)) {
					$reaction = $('#' + idMap[this.id]).next('.reaction');
					html = $('#reaction-template').tmpl(this.comments);
					// $reaction.html(html).fadeTo('fast', 1.0);
					$reaction.html(html);
				}
			});

			if (callback !== undefined) callback();
		});
	};

})(jQuery);


jQuery(function($) {
	var
		hideAllReactions = function (frame, callback) {
			$('.post_frame').not(frame)
				.find('.reaction').hide();
			if (callback !== undefined) callback();
		}

		unsetActiveFrame = function (callback) {
			var $currentFrame = $('.post_frame.active');

			$currentFrame
				.removeClass('active')
				.find('.reaction').hide();
			$.getMiniComments($currentFrame, callback);
		},

		showAllReactions = function () {
			$('.reaction').show();
		},

		showRollCall = function () {
			$('#rollcall').fadeTo('fast', 1.0);
		},

		hideRollCall = function () {
			$('#rollcall').fadeTo('slow', 0.0);
		},

		setWideFrameBorders = function () {
			$('.post_frame, .post').removeClass('narrow-border');
		},

		setNarrowFrameBorders = function () {
			$('.post_frame, .post').addClass('narrow-border');
		};

	// Hide post frames until we know their heights
	$('.post_frame').css({ visibility: 'hidden' });

	// Initialize rollcall headshots
	$('div.headshot').headshot();

	// Initialize unpublish overlay
	$('a.remove[rel="#unpublish_overlay"]').unpublishOverlay();


	// Comments
	$('.comments a, a.comments')
		.live('ajax:beforeSend', function() {
			var $frame = $(this).closest('.post_frame');

			if ($frame.hasClass('active')) {
				unsetActiveFrame(function() {
					setWideFrameBorders();
					showAllReactions();
				});
				return false;
			}
			setNarrowFrameBorders();
			return true;
		})

		.live('ajax:success', function(xhr, form) {
			var $this = $(this),
				$form = $(form),
				$frame = $this.closest('.post_frame'),
				$reaction = $frame.find('.reaction');

			$form.shakeable();
			
			hideAllReactions($frame, function() {
				unsetActiveFrame();
				$frame.addClass('active');
				$reaction
					.css({ opacity: 0.0 })
					.html($form)
					.fadeTo('slow', 1.0, function() {
						$('a.remove[rel="#unpublish_overlay"]', $reaction).unpublishOverlay();
						// $(this).find('.comment_box:first textarea').focus();
					});
			});
	});

	$('.reaction').live('click', function(event) {
		if (event.target.value === 'Cancel') {
			var $frame = $(this).closest('.post_frame');
			unsetActiveFrame(function() {
				setWideFrameBorders();
				showAllReactions();
			});
			return false;
		}
	});


	// Nested Comments
	$('.comment_box .reply a')
		.live('ajax:success', function(xhr, form) {
			var $form = $(form);

			$form.shakeable();

			$(this).hide();
			$form.hide()
				.css({ opacity: 0.0 })
				.insertAfter($(this)
				.closest('.comment_box'))
					.slideDown('fast', function() {
						$form.fadeTo('fast', 1.0, function() {
							$form.find('textarea').focus();
						});
					});
		});

	$('.comment_box.nested input.cancel').live('click', function() {
		var $commentBox = $(this).closest('.comment_box'),
			$prevCommentBox = $commentBox.prev('.comment_box');
		$commentBox.fadeTo('fast', 0.0, function() {
			$(this).slideUp('fast', function() {
				$(this).remove();
				$prevCommentBox.find('.reply a').show();
			});
		});
		return false;
	});


	// Videos
	$('<script>')
		.attr('src', 'http://www.youtube.com/player_api')
		.attr('type', 'text/javascript')
		.insertBefore('script:first');


	// Nav
	$('.new_post_frame')
		.hide()
		.find('input.cancel').navCancel();

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


jQuery(window).load(function() {

	var $frames = $('.post_frame');

	$frames.each(function() {
		var $this = $(this),
			$post = $this.find('.post'),
			height = $post.height() + 20,
			limit = Math.floor(height/50);

		$this
			.height(height)
			.css({ visibility: 'visible' })
			.data('limit', limit);
	});

	$.getMiniComments($frames, function() {
		$frames.find('.reaction').fadeTo('fast', 1.0);
		// $.waypoints('refresh');
	});

});

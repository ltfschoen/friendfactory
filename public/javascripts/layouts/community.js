(function($) {

	$.initPost = function(frame) {
		var $this = $(frame),
			$post = $this.find('.post'),
			height = $post.height() + 20,
			limit = Math.floor(height/50);

		$this
			.height(height)
			.css({ visibility: 'visible' })
			.data('limit', limit)
			.find('a.remove[rel="#unpublish_overlay"]')
				.unpublishOverlay();
	};

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


	$.unsetActiveFrame = function (callback) {
		var $currentFrame = $('.post_frame.active');

		$currentFrame
			.removeClass('active')
			.find('.reaction').hide();
		$.getMiniComments($currentFrame, callback);
	};


	$.hideAllReactionsExcept = function (frame, html, callback) {
		var $frame = $(frame),
			$reaction = $frame.find('.reaction');

		$('.post_frame').not(frame)
			.find('.reaction').hide();

		$.unsetActiveFrame();
		$frame.addClass('active');
		$reaction
			.css({ opacity: 0.0 })
			.html(html)
			.fadeTo('slow', 1.0, function() {
				$('a.remove[rel="#unpublish_overlay"]', $reaction).unpublishOverlay();
				if (callback !== undefined) callback();
			});
	};

})(jQuery);


jQuery(function($) {
	var
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

	// Comments
	$('.comments a, a.comments')
		.live('ajax:beforeSend', function() {
			var $frame = $(this).closest('.post_frame');

			if ($frame.hasClass('active')) {
				$.unsetActiveFrame(function() {
					setWideFrameBorders();
					showAllReactions();
				});
				return false;
			}
			setNarrowFrameBorders();
			return true;
		})

		.live('ajax:success', function(xhr, html) {
			var $this = $(this),
				$html = $(html),
				$frame = $this.closest('.post_frame');

			$html
				.filter('.comment_box:first')
				.shakeable();

			$.hideAllReactionsExcept($frame, $html, function() {
				// $(this).find('.comment_box:first textarea').focus();
			});
		});


	// Albums
	$('a.album')
		.live('ajax:beforeSend', function() {
			var $frame = $(this).closest('.post_frame');

			if ($frame.hasClass('active')) {
				$.unsetActiveFrame(function() {
					setWideFrameBorders();
					showAllReactions();
				});
				return false;
			}
			setNarrowFrameBorders();
			return true;
		})

		.live('ajax:success', function(xhr, html) {
			var $html = $(html),
				$frame = $(this).closest('.post_frame');

			$.hideAllReactionsExcept($frame, $html);
		});


	// Reaction cancel
	$('.reaction').live('click', function(event) {
		if (event.target.value === 'Cancel') {
			var $frame = $(this).closest('.post_frame');
			$.unsetActiveFrame(function() {
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


	// Floating headshots	
	$('.portrait a[href^="/wave/profiles"]')
		.live('click', function(event) {
			var $this = $(this),
				url = $this.attr('href');

			event.preventDefault();
			$.get(url, function(data, status, xhr) {
				$(data)
					.addClass('floating')
					.appendTo('#floating')
					.position({
						my: 'left center',
						of: event,
						offset: '30 0',
						collision: 'fit' })
					.draggable()
					.find('div.headshot').headshot();
			});
		});


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
		$.initPost(this);
	});

	$.getMiniComments($frames, function() {
		$frames.find('.reaction').fadeTo('fast', 1.0);
		// $.waypoints('refresh');
	});

});

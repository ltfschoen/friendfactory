(function($) {

	$.initPost = function (frame) {
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
			idDomIdMap = {},
			fetchables = {};

		$.each(frames, function () {
			var $this = $(this),
				$post = $this.find('.post'),
				$reaction = $this.find('.reaction'),
				postId = $post.getId(),
				limit = $this.data('limit');

			if (postId !== undefined) {
				fetchables[postId] = limit;
				idDomIdMap[postId] = { domId: $post.attr('id'), limit: limit };
				$reaction.html('');
			}
		});

		$.getJSON(url, { id: fetchables }, function (data) {
			$.each(data, function() {
				var idDomId = idDomIdMap[this.posting_id],
					domId = idDomId.domId,
					limit = idDomId.limit,
					$reaction,
					html;

				if ((this.comments.length > 0) && (domId !== undefined)) {
					$reaction = $('#' + domId).next('.reaction');
					html = $('#reaction-template').mustache($.extend(this, { limit: limit }));
					$reaction.html(html);
				}
			});

			if (callback !== undefined) callback();
		});
	};


	$.unsetActiveFrame = function () {
		var $currentFrame = $('.post_frame.active');

		$currentFrame
			.removeClass('active')
			.find('.reaction').hide();

		return $currentFrame;
	};

	$.hideAllReactions = function () {
		$('.post_frame').find('.reaction').hide();
	};

	$.showAllReactions = function () {
		$('.post_frame').find('.reaction').show();
	};

	$.hideAllReactionsExcept = function (frame, html, callback) {
		var $frame = $(frame),
			$reaction = $frame.find('.reaction');

		$('.post_frame').not(frame)
			.find('.reaction').hide();

		$.getMiniComments($.unsetActiveFrame());
		$frame.addClass('active');
		$reaction
			.css({ opacity: 0.0 })
			.html(html)
			.fadeTo('slow', 1.0, function () {
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
	$('div.post_frame').css({ visibility: 'hidden' });

	// Do postings' own initialization
	$('div.posting').posting();

	// Headshots in sidebar
	$('div.headshot', '#sidebar').headshot();

	// Broken Images
	$('img').error(function () {
		$(this).addClass('invisible');
	});

	// Comments
	$('.post .comments a, ul.fetched.comments .comment a, .reaction a.comments.footer')
		.live('ajax:beforeSend', function () {
			var $frame = $(this).closest('.post_frame');

			if ($frame.hasClass('active')) {
				$.getMiniComments($.unsetActiveFrame(), function () {
					setWideFrameBorders();
					showAllReactions();
				});
				return false;
			}
			setNarrowFrameBorders();
			return true;
		})

		.live('ajax:success', function (xhr, html) {
			var $this = $(this),
				$html = $(html),
				$frame = $this.closest('.post_frame');

			$html
				.find('.headshot').headshot().end()
				.find('input[type="text"], textarea').placeholder().end()
				.filter('.comment_box:first')
				.shakeable();

			$.hideAllReactionsExcept($frame, $html, function () {});
		});

	// Reaction cancel
	$('.reaction').live('click', function (event) {
		if (event.target.value === 'Cancel') {
			var $frame = $(this).closest('.post_frame');
			$.getMiniComments($.unsetActiveFrame(), function () {
				setWideFrameBorders();
				showAllReactions();
			});
			return false;
		}
	});

	// Nested Comments
	$('.comment_box .reply a')
		.live('ajax:success', function (xhr, form) {
			var $form = $(form);

			$form.shakeable();

			$(this).hide();
			$form.hide()
				.css({ opacity: 0.0 })
				.insertAfter($(this)
				.closest('.comment_box'))
					.slideDown('fast', function () {
						$form.fadeTo('fast', 1.0, function () {
							$form
								.find('input[type="text"], textarea').placeholder().end()
								.find('textarea').focus();
						});
					});
		});

	// Comments to Photos
	$('a.new_comment')
		.live('ajax:success', function (xhr, form) {
			var $form = $(form);
			$form
				// .shakeable()
				// .hide()
				// .css({ opacity: 0.0 })
				.insertBefore(this);
		});

	$('.comment_box.nested input.cancel').live('click', function () {
		var $commentBox = $(this).closest('.comment_box'),
			$prevCommentBox = $commentBox.prev('.comment_box');

		$commentBox.fadeTo('fast', 0.0, function () {
			$(this).slideUp('fast', function () {
				$(this).remove();
				$prevCommentBox.find('.reply a').show();
			});
		});
		return false;
	});

});


jQuery(window).load(function () {

	var $frames = $('.post_frame'),
		$sidebar = $('#sidebar'),
		$logout = $sidebar.find('.logout'),
		documentHeight = $(document).height(),
		sidebarHeight = $logout.position().top + $logout.outerHeight(true);

	if (sidebarHeight > $(window).height()) {
		if (sidebarHeight > documentHeight) {
			$sidebar.height(sidebarHeight);
			$('#frame').height(sidebarHeight);
		} else {
			$sidebar.height(documentHeight)
		}

		$sidebar.addClass('small-screen');
	}

	$frames.each(function () {
		$.initPost(this);
	});

	$.getMiniComments($frames, function () {
		$frames.find('.reaction').fadeTo('fast', 1.0);
		// $.waypoints('refresh');
	});

});

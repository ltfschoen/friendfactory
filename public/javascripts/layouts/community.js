(function($) {

	$.initPost = function (frame) {
		var $this = $(frame),
			$post = $this.find('.post'),
			height = $post.height() + 20,
			limit = Math.floor(height / 50);

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

		if (frames.length === 0) {
			return;
		}

		$.each(frames, function () {
			var $posting = $(this),
				// $posting = $this,
				// $post = $this.find('.post'),
				$reaction = $posting.find('.reaction'),
				postId = $posting.getId(),
				limit = $posting.data('limit');

			if (postId !== undefined) {
				fetchables[postId] = limit;
				idDomIdMap[postId] = { domId: $posting.attr('id'), limit: limit };
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
					// $reaction = $('#' + domId).next('.reaction');
					$reaction = $('.reaction', '#' + domId);
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

	// Fetchables
	// $('.posting')
	$('#frame')
		.on('click', 'div.posting a.comments', function (event) {
			var $this = $(this),
				$posting = $this.closest('.posting'),
				// $posting = $(event.delegateTarget),
				toggle = ($this.closest('.post', $posting).length > 0);

			if (toggle && $posting.hasClass('active')) {
				$.getMiniComments($.unsetActiveFrame(), function () {
					setWideFrameBorders();
					showAllReactions();
				});
				return false;
			}
			setNarrowFrameBorders();
			return true;
		})

		.on('ajax:success', 'div.posting a.comments', function (event, html, xhr) {
			var // $posting = $(event.delegateTarget),
				$posting = $(this).closest('.posting'),
				$html = $(html);

			$html
				.find('.headshot').headshot().end()
				.find('input[type="text"], textarea').placeholder().end()
				.filter('.comment_box')
				.shakeable();

			$.hideAllReactionsExcept($posting, $html);
		})

		.on('click', 'input.cancel', function (event) {
			var $commentBox = $(this).closest('.comment_box'),
				nested = $commentBox.hasClass('nested'),
				$trigger;

			if (nested) {
				$commentBox.prev('.posting').find('a.new_comment')
					.removeClass('invisible');

				$commentBox.fadeTo('fast', 0.0, function () {
					$(this).slideUp('fast', function () {
						$(this).remove();
						$trigger.removeClass('invisible');
					});
				})
			} else {
				$.getMiniComments($.unsetActiveFrame(), function () {
					setWideFrameBorders();
					showAllReactions();
				});
			}
			return false;
		})

		.on('ajax:success', 'div.posting a.new_comment', function (event, html, xhr) {
			var $this = $(this),
				$form = $(html),
				$preceding;

			if ($this.hasClass('reply')) {
				$preceding = $this.closest('.posting');
			} else {
				$preceding = $this.prev('.posting');
			}

			$this.addClass('invisible');

			$form.hide()
				.shakeable()
				.css({ opacity: 0.0 })
				.insertAfter($preceding)
				.slideDown('fast', function () {
					$form.fadeTo('fast', 1.0, function () {
						$form
							.find('input[type="text"], textarea').placeholder().end()
							.find('textarea').focus();
					});
				});
		})

		.filter('.wave_album').find('.reaction')
			.on('click', 'input.cancel', function (event) {
				var $commentBox = $(this).closest('.comment_box'),
					nested = $commentBox.hasClass('nested'),
					$trigger;

				if (nested) {
					return true
				} else {
					$trigger = $commentBox.next('a.new_comment')
					$commentBox.fadeTo('fast', 0.0, function () {
						$(this).slideUp('fast', function () {
							$(this).remove();
							$trigger.removeClass('invisible');
						});
					});
					return false;
				}
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

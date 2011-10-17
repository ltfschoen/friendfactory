jQuery(function($) {

	var
		hideCurrentReaction = function(callback) {
			$('.post_frame.active')
				.removeClass('active')
				.find('.reaction').fadeOut('fast', function() {
					$(this).html('');
					if (callback !== undefined) callback();
				});
			},

		showRollCall = function() {
			$('#rollcall').fadeTo('fast', 1.0);
		},

		hideRollCall = function() {
			$('#rollcall').fadeTo('slow', 0.0);
		};


	// Initialize postings' height
	$('#frame').css({ visibility: 'hidden' });


	// Initialize Rollcall Headshots
	$('div.headshot').headshot();


	// Comments
	$('.comments a')
		.live('ajax:beforeSend', function() {
			var $frame = $(this).closest('.post_frame');
			if ($frame.hasClass('active')) {
				hideCurrentReaction(showRollCall);
				return false;
			}
			hideRollCall();
		})

		.live('ajax:success', function(xhr, form) {
			var $this = $(this),
				$form = $(form);
			$form.shakeable();
			hideCurrentReaction();
			$this.closest('.post_frame').addClass('active')
				.find('.reaction').html($form)
					.fadeIn('fast', function() {
						$(this).find('.comment_box:first textarea').focus();
					});
	});

	$('.reaction').live('click', function(event) {
		if (event.target.value === 'Cancel') {
			hideCurrentReaction(showRollCall);
			return false;
		}
	});


	// Nested Comments
	$('.comment_box .reply a')
		.live('ajax:success', function(xhr, form) {
			var $form = $(form);
			$form.shakeable();
			$(this).hide();
			$form.hide().css({ opacity: 0.0 }).insertAfter($(this).closest('.comment_box'))
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


	// Unpublish Overlay
	$('a.remove[rel="#unpublish_overlay"]').unpublishOverlay();


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
			
	// $('a[href^="/wave/profiles"].profile', '.attachment').live('click', function(event) {
	// 	event.preventDefault();
	// 	$('<div class="floating"></div>')
	// 		.appendTo('.floating-container')
	// 		.load($(this).attr('href'), function() {
	// 			$(this).position({
	// 				my: 'left center',
	// 				of: event,
	// 				offset: '30 0',
	// 				collision: 'fit'
	// 			})	
	// 			.draggable()
	// 			.find('div.polaroid')
	// 				.polaroid({ 'close-button' : true });
	// 		});
	// });
});


jQuery(window).load(function() {
	$.each($('.post_frame'), function() {
		var post = $(this).find('.post').height();
		$(this).height(post + 20);
	});
	// $.waypoints('refresh');
	$('#frame, #sidebar .block.userspace')
		.css({ visibility: 'visible' });
});

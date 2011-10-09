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
	$.each($('.post_frame'), function() {
		var post = $(this).find('.post').height();
		$(this).height(post+20);
	});

	// Rollcall
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

	// $('.nav-container')
	// 	.insertAfter('ul.posting_post_its:first')
	// 	.find('form')
	// 	.trigger('reset');

	$('a', 'ul.wave.community.nav')
		.bounceable()
		.shakeable();

	// $('a[rel]:not([rel="#posting_post_it"])', 'ul.wave.community.nav')
	// 	.click(function(event) {
	// 		var $this = $(this),
	// 			$tab_content = $($this.attr('rel'));
	// 			
	// 		event.preventDefault();					
	// 		if (!$this.closest('li').hasClass('current')) {
	// 			$this.trigger('bounce')
	// 				.closest('li')
	// 				.addClass('current');
	// 			
	// 			$tab_content
	// 				.css({ opacity: 0.0, visibility: 'hidden' })
	// 				.prependTo('.tab_contents')
	// 				.delay(1200)
	// 				.slideDown(function() {
	// 					$tab_content
	// 						.css({ visibility: 'visible' })
	// 						.fadeTo('fast', 1.0);
	// 				});					
	// 		} else {
	// 			$this.trigger('shake');
	// 		}	
	// 	});


	function insertPostItsContainer() {
		$('<ul class="posting_post_its clearfix"></ul>')
			.hide()
			.insertBefore('ul.postings:first')
			.delay(1200)
			.slideDown(function() {
			});
	}
	
	
	function insertPostIt(postIt) {
		return $(postIt).clone()
			.css({ width: 0, opacity: 0.0 })
			.prependTo('ul.posting_post_its:first')
			.wrap('<li>');
	}
	
	
	function revealFirstPostIt(postIt) {
		insertPostIt(postIt);		
		$('form', 'ul.posting_post_its:first li:first')
			.animate({ width: 187 }, 'slow', function() {
				$(this).fadeTo('fast', 1.0)
					.find('textarea').focus();
			});
	}


	function dropLastPostIt() {
		$('.canvas', 'ul.posting_post_its:first li:eq(4)')
			.hide('drop', { direction: 'down' }, 900);
	}


	// $('a[rel="#posting_post_it"]', 'ul.wave.nav')
	// 	.click(function(event) {
	// 		var $this = $(this);
	// 		
	// 		event.preventDefault();			
	// 		if (true || !$this.closest('li').hasClass('current')) {
	// 			$this.trigger('bounce')
	// 				.closest('li').addClass('current');
	// 			
	// 			if ($('ul.posting_post_its').length === 0) {
	// 				insertPostItsContainer();
	// 			}			
	// 			
	// 			setTimeout(dropLastPostIt, 1100);
	// 
	// 			var postItForm = $($this.attr('rel')).find('form'),
	// 				delay = ($('li', 'ul.posting_post_its:eq(0)').length) < 5 ? 900 : 2000;
	// 			setTimeout(function() { revealFirstPostIt(postItForm) }, delay);
	// 			
	// 		} else {
	// 			$this.trigger('shake');
	// 		}			
	// 	});
			
	// $('.posting, form.new_posting').trigger('init');
	
	// $('.remove', '.posting-container').button({ icons: { primary: 'ui-icon-close' }, text: false });

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


$(window).load(function() {
	// $.waypoints('refresh');
});

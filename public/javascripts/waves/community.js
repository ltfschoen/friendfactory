(function($) {
	
	$.fn.insertNavContent = function() {
		var $this = $(this), height = $this.height();		
		var $insertLocation;
		
		if ($('ul.posting_post_its').length > 0) {
			$insertLocation = $('ul.posting_post_its:first').closest('li').next('li');
		} else {
			$insertLocation = $('li:first', 'ul.postings');
		}
		
		return $(this)		
			.css({ opacity: 0.0 })
			.hide()
			.insertBefore($insertLocation)
			.delay(1200)
			.slideDown(function() {
				$(this).fadeTo('slow', 1.0);
			});
	}
	
})(jQuery);


jQuery(function($) {	

	$('.tab_contents')
		.insertAfter('ul.posting_post_its:first');

	$('.tab_content')
		.filter('#posting_post_it, #posting_text, #posting_post_it')
			.bind('reset', function(event) {
				$('form', this).get(0).reset();
				$('textarea, input', this).placehold();
			})
		.end()
		
		.filter('#posting_photo')
			.bind('reset', function(event) {
				var $this = $(this);
				var $target = $('a[rel="#' + $this.attr('id') +'"]', 'ul.wave.community.nav')
	
				$this.load($target.attr('href') + ' form', function(event) {
					$(this)
						.find('button.cancel, a.cancel')
							.button({ icons: { primary: 'ui-icon-close' }})
						.end()					
						.find('button[type="submit"]')
							.button({ icons: { primary: 'ui-icon-check' }})
						.end()					
						.find('textarea')
							.placehold()
						.end()
						.find('textarea', '.post_it.attachment')
							.textareaCount({ 'maxCharacterSize': 70 }, function(data){});
				});				
			});


	$('a', 'ul.wave.community.nav')		
		.bind('bounce', function() {
			var $this = $(this);

			if (Modernizr.cssanimations) {				
				$this.bind('webkitAnimationEnd', function(event) {
					$this.removeClass('bounce');
				})
				.addClass('bounce')
						
			} else {
				$this
					.animate({ top: -15 }, 600)
					.delay(100)
					.animate({ top: 30 }, 100)
					.animate({ top: 0 }, 500);				
			}
		})
		
		.bind('shake', function() {
			var $this = $(this);
			
			if (Modernizr.cssanimations) {				
				$this.bind('webkitAnimationEnd', function(event) {
					$this.removeClass('shake');
				})
				.addClass('shake');
				
			} else {
				$this
					.animate({ left: -3 }, 50)
					.animate({ left: 3 }, 50)
					.animate({ left: 0 }, 50);
			}		
		});


	// $('a[rel]:not([rel="#posting_post_it"])', 'ul.wave.community.nav')
	$('a[rel="#posting_text"], a[rel="#posting_photo"], a[rel="#posting_video_upload"], a[rel="#wave_album"]', 'ul.wave.community.nav')
		.click(function(event) {		
			event.preventDefault();			
			var $this = $(this);
						
			if (!$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li')
					.addClass('current');					
					
				var $tab_content = $($this.attr('rel'));
				
				$tab_content
					.css({ opacity: 0.0 })
					.prependTo('.tab_contents')
					.delay(1200)
					.slideDown(function() {
						$tab_content.fadeTo('fast', 1.0);
					});
					
			} else {
				$this.trigger('shake');				
			}	
		});
	

	// $('a[href^="#"]', '.wave_community ul.nav')
	// 	.click(function(event) {
	// 		event.preventDefault();
	// 		var $this = $(this);
	// 	
	// 		if (!$this.closest('li').hasClass('current')) {
	// 			$this.trigger('bounce')
	// 				.closest('li')
	// 				.addClass('current');
	// 		
	// 			$('form', 'a[name="' + $(this).attr('href').substring(1) + '"]')
	// 				.insertNavContent();
	// 			
	// 		} else {
	// 			$this.trigger('shake');
	// 		}
	// 	});

	$('button.cancel', '.tab_content')
		.bind('click', function(event) {
			event.preventDefault();
			var $tabContent = $(this).closest('.tab_content');
			
			$('a[rel="#' + $tabContent.attr('id') +'"]', 'ul.wave.community.nav')
				.closest('li').removeClass('current');
			
			$tabContent.fadeTo('fast', 0.0, function() {
				$tabContent.slideUp(800, 'easeOutBounce', function() {
					$tabContent.trigger('reset');
				});
			});
		});


	$('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well', '.cssanimations .tab_content')
		.bind('pulse', function(event, operation) {
			if (operation === 'start') {
				$(this).addClass('pulse');
			} else {
				$(this).removeClass('pulse');				
			}
		});

	$('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well', '.no-cssanimations .tab_content')
		.bind('pulse', function(event, operation) {
			var $this = $(this);
			
			if (operation === 'start') {
				var worker = setInterval(function() {
					$this.fadeTo(300, 0.5).fadeTo(300, 1.0);				
				}, 600);
				$this.attr('data-worker', worker);
			} else {			
				clearInterval($this.attr('data-worker'));
				$this.removeAttr('data-worker');
			}
		});


	$('form', '.tab_content')
		.live('ajax:loading', function() {
			$(this)
				.find('.button-bar')
					.fadeTo('fast', 0.0)
				.end()
				.find('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well')
					.trigger('pulse', 'start');
		})
		.live('ajax:complete', function() {
			$(this)
				.find('.button-bar')
					.fadeTo('fast', 1.0)
				.end()
				.find('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well')
					.trigger('pulse', 'stop');
		});

		
	$('.tab_content#posting_photo')
		.find('input[type="file"]')
			.live('change', function(event) {
				$(event.target.form).submit();
			})
		.end()
		.find('form.edit_posting_photo button#posting_photo_cancel')
			.live('click', function(event) {
		        $(this).callRemote();
			});
	
	$('button', '.tab_content#posting_post_it, .tab_content#posting_text')
		.button({ text: false });
			
	$('textarea', '.tab_content#posting_post_it')
		.textareaCount({ 'maxCharacterSize': 108 });

	$('textarea', '.tab_content .post_it.attachment')
		.textareaCount({ 'maxCharacterSize': 70 }, function(data){});

});

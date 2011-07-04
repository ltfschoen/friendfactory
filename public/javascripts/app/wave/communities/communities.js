jQuery(function($) {	
		
	$('.tab_contents')
		.insertAfter('ul.posting_post_its:first');
	
	$('.tab_content')
		.bind('reset', function(event) {
			$('form', this).get(0).reset();
			$('textarea, input', this).placehold();
		})
		.trigger('reset');
	
	$('a', 'ul.wave.community.nav').bounceable().shakeable();

	$('a[rel]:not([rel="#posting_post_it"])', 'ul.wave.community.nav')
		.click(function(event) {
			
			var $this = $(this),
				$tab_content = $($this.attr('rel'));
				
			event.preventDefault();			
						
			if (!$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li')
					.addClass('current');					
				
				$tab_content
					.css({ opacity: 0.0, visibility: 'hidden' })
					.prependTo('.tab_contents')
					.delay(1200)
					.slideDown(function() {
						$tab_content
							.css({ visibility: 'visible' })						
							.fadeTo('fast', 1.0);
					});
					
			} else {
				$this.trigger('shake');				
			}	
		});


	$('form', '.tab_content')
		.live('ajax:loading', function() {
			$(this)
				.find('.button-bar')
					.fadeTo('fast', 0.0)
				.end()
				.find('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well').pulse();
		})
		.live('ajax:complete', function() {
			$(this)
				.find('.button-bar')
					.fadeTo('fast', 1.0)
				.end()
				.find('.text.canvas, .post_it:not(.attachment), #posting_photo_upload_well, #posting_video_upload_well').pulse();
		});

			
	$('textarea', '.tab_content#posting_post_it')
		.textareaCount({ 'maxCharacterSize': 108 });

	$('textarea', '.tab_content .post_it.attachment')
		.textareaCount({ 'maxCharacterSize': 70 }, function(data){});

	$('.wave_community').community();	
		
	$('a.new_posting_comment', '.wave_community')
		.live('click', function(event) {
			var $this = $(this);
						
			event.preventDefault();			
			$this
				.fadeTo('fast', 0.0, function() {
					$this
						.closest('.posting-container')
						.find('.posting_comment.editable')
							.css({ opacity: 0.0 })
							.slideDown('fast')					
							.fadeTo('fast', 1.0)
							.find('textarea').focus();					
				});

			$.waypoints('refresh');			
		});

	
	(function() {		
		var $loading = $("<p class='loading grid_4 push_6'>Loading More Postings&hellip;</p>"),
			$footer = $('.wave_community + .page.footer'),
			opts = { offset: '110%' };
		
		if ($('.pagination').length === 0) return;
		
		$footer.waypoint(function(event, direction) {			
			var $pagination = $('.pagination'),
				href = $("a[rel='next']", $pagination).attr('href');
			
			$footer.waypoint('remove');
			$pagination.html($loading).pulse();
			
			$.get(href, function(data) {
				var $data = $(data),
					$content = $data.find('#postings-container');

				$('#postings-container').append($content);

				$content
					.find('.posting_comment.editable')
						.comment();
								
				$('.polaroid-container > .polaroid', $content).polaroid();					
				
				setTimeout(function() {
					$('.posting_photos', $content)
						.masonry({
							singleMode: false,
							columnWidth: 1,
							itemSelector: 'li',
							resizeable: false
						});
						
					$('.posting_comments', $content)
						.masonry({
							singleMode: false,
							columnWidth: 222,
							itemSelector: 'li',
							resizeable: false
						});
						
					$.waypoints('refresh');
				}, 1200);

				$pagination.replaceWith($data.find('.pagination'));
				$footer.waypoint(opts);
			});
		}, opts);
	})();
			
});


$(window).load(function() {

	$('.posting_photos', '.wave_community')
		.masonry({
			singleMode: false,
			columnWidth: 1,
			itemSelector: 'li',
			resizeable: false
		});
	
	$('.posting_comments', '.wave_community')
		.masonry({
			singleMode: false,
			columnWidth: 222,
			itemSelector: 'li',
			resizeable: false
		});
	
	$.waypoints('refresh');	
});

jQuery(function($) {	
		
	$('.nav-container')
		.insertAfter('ul.posting_post_its:first')
		.find('form')
		.trigger('reset');
		
	$('a', 'ul.wave.community.nav')
		.bounceable()
		.shakeable();

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


	$('a[rel="#posting_post_it"]', 'ul.wave.nav')
		.click(function(event) {
			event.preventDefault();
			var $this = $(this);
			
			if (true || !$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li').addClass('current');

				
				if ($('ul.posting_post_its').length === 0) {
					insertPostItsContainer();
				}				
				
				setTimeout(dropLastPostIt, 1100);

				var postItForm = $($this.attr('rel')).find('form');
				var delay = ($('li', 'ul.posting_post_its:eq(0)').length) < 5 ? 900 : 2000;
				setTimeout(function() { revealFirstPostIt(postItForm) }, delay);
				
			} else {
				$this.trigger('shake');
			}			
		});
			
	$('.posting').trigger('init');
		
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

				$content.find('.posting_comment').trigger('init');
								
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

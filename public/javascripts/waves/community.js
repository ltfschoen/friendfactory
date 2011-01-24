jQuery(function($) {
	
	$('.tab_content')
		.filter('#posting_post_it, #posting_text')
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
						.find('textarea').placehold();				
				});				
			});			
			

	$('a', 'ul.wave.community.nav').live('click', function(event) {		
		event.preventDefault();
		
		var $this = $(this);		
		if (!$this.closest('li').hasClass('current')) {

			var $tab_content = $($this.attr('rel'));

			$this.addClass('bounce')
				.closest('li')
					.addClass('current');		
			
			$tab_content.prependTo('.tab_contents').delay(1200).slideDown(function() {
				$this.removeClass('bounce');
			});
		} else {
			$this.bind('webkitAnimationEnd', function(event) {
				$this.removeClass('shake');
			});
			$this.addClass('shake');
		}	
	});


	$('button.cancel, button#posting_photo_cancel', '.tab_content')
		.live('click', function(event) {
			event.preventDefault();
			var $tabContent = $(this).closest('.tab_content');
			
			$('a[rel="#' + $tabContent.attr('id') +'"]', 'ul.wave.community.nav')
				.closest('li')
					.removeClass('current');
			
			$tabContent.slideUp(function() {
				$tabContent.trigger('reset');
			});
		});


	$('form', '.tab_content')
		.live('ajax:loading', function() {
			$(this)
				.find('.button-bar')
					.css('visibility', 'hidden')
				.end()
				.find('.index-card, .post_it, #posting_photo_upload_well')
					.addClass('pulse');
		})
		.live('ajax:complete', function() {
			$(this)
				.find('.button-bar')
					.css('visibility', 'visible')
				.end()
				.find('.index-card, .post_it, #posting_photo_upload_well')
					.removeClass('pulse');			
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

});

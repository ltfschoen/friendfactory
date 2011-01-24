jQuery(function($) {
	
	$('.tab_content')
		.bind('reset', function(event, target) {
			var $this = $(this);
			var $target = $(target);

			$this.hide().load($target.attr('href') + ' form', function(event) {
				$(this)
					.find('button.cancel, a.cancel')
						.button({ icons: { primary: 'ui-icon-close' }})
					.end()					
					.find('button[type="submit"]')
						.button({ icons: { primary: 'ui-icon-check' }})
					.end()					
					.find('textarea').placehold();
				
				$target.addClass('bounce')
					.closest('li').addClass('current');		
			
				$this.prependTo('.tab_contents').delay(1200).slideDown(function() {
					$target.removeClass('bounce');
				});			
			});			
		});
		

	$('a', 'ul.wave.community.nav').live('click', function(event) {		
		event.preventDefault();
		
		var $this = $(this);		
		if (!$this.closest('li').hasClass('current')) {

			var $tab_content = $($this.attr('rel'));
			$tab_content.trigger('reset', this);

			// $this.addClass('bounce')
			// 	.closest('li').addClass('current');		
			// 
			// $tab_content.prependTo('.tab_contents').delay(1200).slideDown(function() {
			// 	$this.removeClass('bounce');
			// });
		} else {
			$this.bind('webkitAnimationEnd', function(event) {
				$this.removeClass('shake');
			});
			$this.addClass('shake');
		}	
	});

	$('button.cancel', '.tab_content')
		.live('click', function(event) {
			event.preventDefault();
			var $tabContent = $(this).closest('.tab_content');
			
			$('a[rel="#' + $tabContent.attr('id') +'"]', 'ul.wave.community.nav')
				.closest('li')
				.removeClass('current');
			
			$tabContent.slideUp(function() {
				$tabContent.empty();
			});
		});

	$('form', '.tab_content:not(#posting_photo)')
		.live('ajax:loading', function() {
			$(this)
				.find('.button-bar')
					.css('visibility', 'hidden')
				.end()
				.addClass('pulse');
		});

	$('form', '.tab_content#posting_photo')
		.live('ajax:loading', function(event) {
			$(this)
				.find('.button-bar')
					.css('visibility', 'hidden')
				.end()
				.find('#posting_photo_upload_well')
					.addClass('pulse');
		})
		.live('ajax:complete', function(event) {
			$(this)
				.find('.button-bar')
					.css('visibility', 'visible')
				.end()
				.find('#posting_photo_upload_well')
					.removeClass('pulse');
		});
		
	$('.tab_content#posting_photo')
		.find('input[type="file"]')
			.live('change', function(event) {
				$(event.target.form).submit();
			})
		.end()
		.find('button#posting_photo_cancel')
			.live('click', function(event) {
				event.preventDefault();
				$(this).closest('.tab_content')
					.slideUp();
			
				$('ul.wave.community.nav')
					.find('a[href="#posting_photo"]')
						.closest('li')
						.removeClass('current')
			})
		.end()
		.find('form.edit_posting_photo button#posting_photo_cancel')
			.live('click', function(event) {
		        $(this).callRemote();
			});

});

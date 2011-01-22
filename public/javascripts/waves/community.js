jQuery(function($) {
	
	$('.tab_content').bind('reset', function(event) {
		$(event.target)
			.find('form')[0].reset();
	});
		
	$('#posting_photo.tab_content').bind('reset', function(event) {		
		var silhouette_tag = '<img alt="Silhouette-q" class="photo h4x6 small silhouette" src="/images/silhouette-q.gif">'
		$(event.target)
			.find("#posting_photo_upload_well").html(silhouette_tag);
	});

	$('a', 'ul.wave.community.nav').live('click', function(event) {		
		event.preventDefault();
		
		var $this = $(this);		
		if (!$this.closest('li').hasClass('current')) {

			var $tab_content = $($this.attr('href'));
			$tab_content.trigger('reset');

			$this.closest('li').addClass('current');		
			$this.addClass('bounce');
			
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

	$('button.cancel', '.tab_content')
		.click(function(event) {
			event.preventDefault();
			
			var $tabContent = $(this).closest('.tab_content')

			$('a[href="#' + $tabContent.attr('id') +'"]', 'ul.wave.community.nav')
				.closest('li')
				.removeClass('current');
			
			$tabContent
				.slideUp()				
				.find('textarea').val('').placehold();
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
		.end();
	
	$('button:not([type="submit"])', '.tab_content#posting_photo')
		.live('click', function(event) {
			event.preventDefault();
			$(this).closest('.tab_content')
				.slideUp()
				.find('textarea').val('').placehold();
			
			$('ul.wave.community.nav')
				.find('a[href="#posting_photo"]')
				.closest('li')
				.removeClass('current')
		});

});

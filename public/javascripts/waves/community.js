jQuery(function($) {

	$('a', 'ul.wave.community.nav').live('click', function(event) {		
		event.preventDefault();
		
		var $this = $(this);		
		if (!$this.closest('li').hasClass('current')) {

			var $tab_content = $($this.attr('href'));
			$tab_content.find('form')[0].reset();

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
		.bind('ajax:loading', function(event) {
			$(this).find('.button-bar').css('visibility', 'hidden');
		})
		.bind('ajax:complete', function(event){
			$(this).find('.button-bar').css('visibility', 'visible');
		});
		
	$('input[type="file"]', '.tab_content#posting_photo').live('change', function(event) {
		$(event.target.form).submit();
	});
	
	$('button:not([type="submit"])', '.tab_content#posting_photo').live('click', function(event) {
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

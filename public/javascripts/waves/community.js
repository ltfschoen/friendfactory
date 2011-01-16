jQuery(function($) {

	// Tabs
	// $('.wave.community.nav li:eq(0)').button({ icons: { primary: 'ui-icon-pencil' }});
	// $('.wave.community.nav li:eq(1)').button({ icons: { primary: 'ui-icon-image' }});
	// $('#tabs li:eq(2)').button({ icons: { primary: 'ui-icon-video' }});
	// $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-comment' }});
	// $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-link' }});
	// $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-clock' }});
	// $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-signal' }});

	$('ul.wave.community.nav a').live('click', function(event) {		
		event.preventDefault();
		$this = $(this);
		
		if (!$this.closest('li').hasClass('current')) {
			$this.closest('li').addClass('current')
				.siblings('li.current')
				.removeClass('current');

			$this.addClass('bounce');
			$($this.attr('href')).prependTo('.tab_contents').delay(1200).slideDown(function() {
				$this.removeClass('bounce');
			});
		}		
	});

	$('button.cancel', '.tab_content')
		.click(function() {
			$(this)
				.parents('.tab_content')
				.slideUp()
				.find('textarea').val('').placehold();
		
			$('ul.wave.nav li.current')
				.removeClass('current');
		
			return false;
		});

	$('.tab_content.photo form')
		.bind('ajax:before', function(event) {
	  		$(this).hide();
	  		$('#posting_photo_upload_spinner').show();
		});

});

jQuery(document).ready(function($) {  

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');

	// Buttons
	$('button[type="submit"]').button({ icons: { primary: 'ui-icon-check' }});
	$('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

	// Set up static polaroids
	$('.polaroid-container > .polaroid').polaroid();

	// Set up static postcards
	$('.postcard').postcard();

	// Set up static tickets
	$('.ticket-container > .ticket').ticket();
	
	// Set up static click-to-polaroid from a.profile
	$('a[href^="/wave/profiles"].profile').live('click', function(event) {
		event.preventDefault();
		$('<div class="floating"></div>')
			.appendTo('.floating-container')
			.load($(this).attr('href'), function() {	 			
				$(this).position({
					my: 'left center',
					of: event,
					offset: '30 0',
					collision: 'fit'
				})	
				.draggable()
				.find('.polaroid-container > .polaroid')
					.polaroid({ 'close-button' : true });
			});
	});
		
});

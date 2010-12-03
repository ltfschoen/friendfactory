jQuery(document).ready(function($) {  

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');

	// Buttons
	$('button[type="submit"]').button({ icons: { primary: 'ui-icon-check' }});
	$('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

	// Set up polaroids
	$('.polaroid-container > .polaroid').polaroid().find('a.message').postcard();

	// Post-its
	$('a.profile', '.post_it').click(function(event) {
		event.preventDefault();
		$('<div class="floating"></div>')
			.appendTo('.floating-overlay')
			.load($(this).attr('href'), function() {	 			
				$(this)
					.position({
						my: 'left center',
						of: event,
						offset: '30 0',
						collision: 'fit'
					})	
					.draggable()
					.find('.polaroid-container > .polaroid')
						.polaroid({ 'close-button' : true })
						.find('a.message').postcard().end();
			});
	});

	// shared.js was here	
	// comment.js was here
	
});

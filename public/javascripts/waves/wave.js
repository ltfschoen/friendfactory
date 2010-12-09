jQuery(document).ready(function($) {  

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');

	// Buttons
	$('button[type="submit"]').button({ icons: { primary: 'ui-icon-check' }});
	$('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

	// Set up polaroids
	$('.polaroid-container > .polaroid').polaroid();

	// Set up statically rendered postcards (i.e Inbox)
	$('.postcard').postcard().draggable({ cancel: '.grid_5, button' });

	// Set up click-to-polaroid from a.profile
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
	
	// Click-to-postcard
	// $('a[href^="/wave/profiles"].conversation').click(function(event) {
	// 	event.preventDefault();
	// 	$('<div class="floating"></div>')
	// 		.appendTo('.floating-container')
	// 		.load($(this).attr('href'), function() {
	// 			$(this).find('.postcard')
	// 				.postcard()
	// 				.draggable({ cancel: '.thread' })
	// 				.position({
	// 					my: 'left center',
	// 					of: event,
	// 					offset: '30 0',
	// 					collision: 'fit'
	// 				})
	// 				.find('textarea').focus();					
	// 		});
	// });

	// // Floating bring to front
	// $('.floating').live('mousedown', function(event) {
	// 	$(event.target).closest('.floating').bringToFront();
	// });
		
});

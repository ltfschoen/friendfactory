jQuery(function($) {

	$('button, .button').button();
	$("button[type='submit']").button({ icons: { primary: 'ui-icon-check' }});

	$('button.toggle').click(function(event) {
		event.preventDefault();
		$('.panel.login, .panel.signup').toggle();
	});

	$('input, textarea').placehold();
	
});

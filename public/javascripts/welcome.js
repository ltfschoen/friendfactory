jQuery(function($) {

	$('button, .button').button();
	$("button[type='submit']").button({ icons: { primary: 'ui-icon-check' }});

	$('button.toggle').click(function(event) {
		event.preventDefault();
		$('.panel.login, .panel.signup').toggle();
	});

	$('input:not([type="hidden"])').placehold();
	
	var $codeInput = $('input#user_invitations_attributes_0_code');
	if (($('li', 'ul.flash.error').length > 0) || ($codeInput.val().length > 0)) {
		$('button.toggle').trigger('click');
	}
	
});

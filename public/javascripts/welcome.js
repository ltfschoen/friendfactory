jQuery(function($) {

	$('button, .button').button();
	$("button[type='submit']").button({ icons: { primary: 'ui-icon-check' }});

	$('button.toggle').click(function(event) {
		event.preventDefault();
		$('.panel.login, .panel.signup').toggle();
	});

	$('input:not([type="hidden"])').placehold();
	
	var $invitationCode = $('input#user_invitation_code').val();
	if ($('li', 'ul.flash.error').length > 0 || $invitationCode.length > 0) {
		$('button.toggle').trigger('click');
	}
	
	$('input#user_email').change(function(event) {
		$.getJSON('/users/member', { email: $(event.target).val() }, function(data) {			
			if (data['member'] == true) {
				$('input#user_password_confirmation').hide();
				$("label[for='user_password']").show();
			} else {
				$('input#user_password_confirmation').show();
				$("label[for='user_password']").hide();				
			}
		});
	});
	
});

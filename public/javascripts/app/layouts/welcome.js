jQuery(function($) {

	$('button, .button').button();
	$("button[type='submit']").button({ icons: { primary: 'ui-icon-check' }});

	$('button.toggle').click(function(event) {
		event.preventDefault();
		$('.panel.login, .panel.signup').toggle();
	});

	if (Modernizr.input.placeholder) {
		$('label.placeholder').hide();		
	}
	
	var $invitationCode = $('input#user_invitation_code');
	if ($('li', 'ul.flash.error').length > 0 || ($invitationCode.length > 0 && $invitationCode.val().length > 0)) {
		$('button.toggle').trigger('click');
	}
	
	$('input#user_email').change(function(event) {
		$.getJSON('/users/member', { email: $(event.target).val() }, function(data) {			
			if (data['member'] == true) {
				$("input#user_password_confirmation, label[for='user_password_confirmation']").hide();
				$("label[for='user_password']:not('.placeholder')").show();
			} else {
				$('input#user_password_confirmation').show();
				if (!Modernizr.input.placeholder) {
					$("label[for='user_password_confirmation']").show();
				}
				$("label[for='user_password']:not('.placeholder')").hide();
			}
		});
	});
	
});

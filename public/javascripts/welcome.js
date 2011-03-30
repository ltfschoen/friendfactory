jQuery(function($) {

	$('button, .button').button();
	$("button[type='submit']").button({ icons: { primary: 'ui-icon-check' }});

	$('button.toggle').click(function(event) {
		event.preventDefault();
		$('.panel.login, .panel.signup').toggle();
	});

	$('input:not([type="hidden"])').placehold();
	
	var $codeInput = $('input#user_invitations_attributes_0_code', $('body').data('site'));
	if (($('li', 'ul.flash.error').length > 0) || (($codeInput.length > 0) && (val().length > 0))) {
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
	}).trigger('change');
	
});

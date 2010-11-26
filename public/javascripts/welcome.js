var FF = {	
	passwordPrompt: function(password_field, password_placeholder_field){
		(function($){
			$(password_placeholder_field).focus(function() {
				$(this).hide();
				$(password_field).show().focus();
			});
			$(password_field).blur(function() {
				if ($(this).val() == '') {
					$(this).hide();
					$(password_placeholder_field).show();
				}
			});			
		})(jQuery);
	},
	
	scrubPlaceholders: function(form) {
	  $(form).children('input[type=text], textarea').each(function(child){
      if ($(this).val().toLowerCase() === $(this).attr('placeholder').toLowerCase()) {
        $(this).val('');
	    }
		});
	}
};

jQuery.fn.log = function (msg) {
    console.log("%s: %o", msg, this);
    return this;
};

var FF = {	
	inspect: function(obj){
		var str = ''; 
		for (var i in obj) {
			str += (i + "='" + obj[i] + "',");
		}
		return str
	},

	log: function(message){
		(function($) {
			$('#log').append("<p>" + message + "</p>");
		})(jQuery);	
	},
	
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

jQuery(document).ready(function($) {
  $('button.cancel, a.cancel').button({ icons: { primary: 'ui-icon-close' }});
  $('a.message').overlay({ top: '30%', target: '#message-postcard' });
  // $('#message-postcard').click(function(){ $(this).fadeOut(); });
  $('a.message').click(function(event) {
  })
});

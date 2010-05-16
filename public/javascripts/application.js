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
	
	password_prompt: function(password_field, password_placeholder_field){
		(function($){
			$(password_placeholder_field).focus(function() {
				$(this).hide();
				$(password_field)
					.show()
					.focus();
			});
			$(password_field).blur(function() {
				if ($(this).val() == '') {
					$(this).hide();
					$(password_placeholder_field).show();
				}
			});			
		})(jQuery);
	},
	
	scrub_placeholders: function(form){
	  $(form).children('input[type=text]').each(function(child){
			if ($(this).val().toLowerCase() === $(this).attr('placeholder').toLowerCase()){
			  $(this).val('');
			}
		});
	}
};

jQuery(document).ready(function($) {
    $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});
	$('.header.secondary').hide().children().hide();
	$('.header.primary #login').toggle(
		function(){
			$('.header.secondary').slideDown('normal', function(){ $(this).children().show(); })
			return false;
		},
		function(){
			$('.header.secondary').children().hide();
			$('.header.secondary').slideUp('normal');
			return false;
		});		
});

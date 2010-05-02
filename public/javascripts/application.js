var FF = {	
	log: function(message) {
		(function($) {
			$('#log').append("<p>" + message + "</p>");
		})(jQuery);	
	},
	
	password_prompt: function(password_field, password_placeholder_field) {
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
	}
};

jQuery(document).ready(function($) {
	$('.header.secondary').hide().children().hide();
	// $('.header.secondary').children().hide();
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
	$('input[placeholder], textarea[placeholder]')
		.placeholder({ className: 'placeholder' })
		.addClass('placeholder');
});

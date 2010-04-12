var FF = {};
(function($){ 
	FF.password_prompt = function(password_field, password_placeholder_field) {
		$(password_placeholder_field).focus(function(){
			$(this).hide();
			$(password_field).show().focus();
		});
		$(password_field).blur(function(){
			if ($(this).val() == '') {
				$(this).hide();
				$(password_placeholder_field).show();
			}
		});
	}
})(jQuery);

jQuery(function($){
	$('.header.secondary').hide();
	$('.header.secondary').children().hide();
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

jQuery(function($) {
	
	$('.wave_invitation')				
		.find('a.new_posting_invitation')
			.click(function(event) {
				var $target = $(event.target),
					eq = $target.closest('li').prevAll('li').length;
					
				event.preventDefault();
				$target
					.closest('.polaroid')
					.find('.button-bar').show()
					.find('input#li_eq').val(eq)
					.siblings('input#posting_invitation_body')
						.removeAttr('disabled');
			})
		.end()
		
		.find('a.edit_posting_invitation')
			.click(function(event) {
				event.preventDefault();
				$(event.target)
					.closest('.polaroid')
					.find('input#posting_invitation_body')
						.attr('disabled', 'disabled')
						.show();
			})
		.end()
		
		.find('form')
			.bind('ajax:success', function() {
				$(this).find('.button-bar').hide();
			})
			
			.find('button.cancel')
				.click(function(event) {
					$(event.target)
						.closest('.button-bar').hide();
					return false;
				})
			.end()
		.end()
		
		.find("input[type='text']")
			.placehold()
		.end()
		
		.find('.button-bar').buttonize();

});


	
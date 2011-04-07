jQuery(function($) {

	$('.polaroid.edit img.thumb', '.cssanimations .wave_invitation')
		.bind('pulse', function() {
			$(this).toggleClass('pulse');
		});
		
	$('.polaroid.edit img.thumb', '.no-cssanimations .wave_invitation')
		.bind('pulse', function() {
			var $this = $(this),
				worker;
			
			if (!$this.hasClass('pulse')) {
				worker = setInterval(function() {
					$this.fadeTo(300, 0.5).fadeTo(300, 1.0);
				}, 600);
				$this.attr('data-worker', worker);

			} else {
				clearInterval($this.attr('data-worker'));
				$this.removeAttr('data-worker');
			}
		});
		
	$('.wave_invitation')
		.find('.polaroid.edit a.new_posting_invitation, .polaroid.edit a.edit_posting_invitation')
			.click(function(event) {
				var $target = $(event.target),
					eq = $target.closest('li').prevAll('li').length,
					email = $target.attr('title'),
					url = $target.data('url'),
					method = $target.data('method');

				event.preventDefault();
				$target
					.closest('.polaroid')
						.find('form').attr('action', url)
							.find('.button-bar').show()
								.find('input#li_eq').val(eq).end()
								.find('input[name="_method"]').attr('value', method).end()
								.find('input#posting_invitation_body').val(email);
			})
		.end()
				
		.find('form')
			.bind('ajax:before', function() {
				var $this = $(this),
					eq = $this.find('input#li_eq').val();
					
				$this
					.find('.button-bar').hide().end()
					.find('li:eq(' + eq + ') img.thumb')
						.trigger('pulse');
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


	
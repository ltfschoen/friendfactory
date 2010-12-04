jQuery(function($) {
	
	$('#postcard').find('form')
		.bind('ajax:success', function(xhr, data, status) {
			var $trigger = $('.polaroid a.message').postcard('trigger');
			setTimeout(function() { $trigger.overlay().close(); }, 900);
		});


	$('.postcard').not('#postcard')
		.find('form')
			.find('.thread')
				.each(function(idx, thread) {
					thread.scrollTop = thread.scrollHeight;
				})
			.end()
	
		.bind('ajax:success', function(xhr, data, status) {
			$this = $(this);
			setTimeout(function() {
				$this
					.find('.franking, .delivered').fadeOut().end()
					.find('textarea').val(''); }, 900);
		})
		
		.bind('ajax:complete', function() {
			$(this).find('textarea').focus();
			var threadDiv = $(this).find('.thread')[0];
			threadDiv.scrollTop = threadDiv.scrollHeight;
		})


	$('form', '.postcard')
		.bind('submit', function() {
			var msg = $(this).find('textarea').val();
			if (msg.length == 0) { return false; }			
		})

		.bind('ajax:loading', function() {
			$(this).find('.franking').fadeIn();
			$(this).find('button[type="submit"]').button('disable');
		})

		.bind('ajax:success', function(xhr, data, status) {
			$(this).find('.delivered').fadeIn();			
		})
	
		.bind('ajax:complete', function() {
			$this = $(this);
			setTimeout(function() { $this.find('button[type="submit"]').button('enable'); }, 900);
		})
	
		.bind('ajax:failure', function() {
			alert("Couldn't send your message. Try again or Cancel.");
		});		

});

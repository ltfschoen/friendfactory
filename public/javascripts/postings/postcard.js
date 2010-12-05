jQuery(function($) {
	
	$('#postcard').find('form')
		.bind('ajax:success', function(xhr, data, status) {
			var $trigger = $('.polaroid a.message').postcard('trigger');
			setTimeout(function() { $trigger.overlay().close(); }, 900);
		});


	// Enter key in textarea
	
	$('.postcard').find('textarea').bind('keydown', function(event) {
		if (event.keyCode == '13') {
			event.preventDefault();
			$(this).closest('form').submit();
		}
	});


	// Pusher
	
	var pusher = new Pusher('064cfff6a7f7e44b07ae');	
	$('.postcard').each(function() {
		var channel_id = $(this).attr('id');
		var channel = pusher.subscribe(channel_id);
		channel.bind('message', function(data) {
			console.dir(data);
			$.get(data['url'], function(partial) {
				var threadDiv = $('.thread', data['dom_id']).append(partial)[0];
				threadDiv.scrollTop = threadDiv.scrollHeight;				
			});
		});
	});

	
	// Postcard setup
	
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
					.find('textarea').val(''); }, 800);
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
			setTimeout(function() { $this.find('button[type="submit"]').button('enable'); }, 800);
		})
	
		.bind('ajax:failure', function() {
			alert("Couldn't send your message. Try again or Cancel.");
		});		

});

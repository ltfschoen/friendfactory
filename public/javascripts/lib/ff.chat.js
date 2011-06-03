(function($) {
	
	$.fn.chat = function() {

		var $this = $(this), // wave_conversation	
			pusher = new Pusher('064cfff6a7f7e44b07ae'),
			channelId = $this.attr('id'),
			channel = pusher.subscribe(channelId);

		channel.bind('message', function(data) {
			$.get(data['url'], function(partial) {
				var $threadDiv = $('.thread', data['dom_id']).append(partial);
				// $threadDiv[0].scrollTop = $threadDiv[0].scrollHeight;
				$threadDiv.scrollTo('max', 200);
			});
		});

		$this
			.find('form')
				.find('button[type="submit"]')
					.hide()
				.end()
				
				.find('textarea')
					.bind('keydown', function(event) {
						if (event.keyCode == '13') {
							event.preventDefault();
							$(this).closest('form').submit();
						} else if (event.keyCode == '27') {
							$(event.target).closest('.postcard')
								.fadeOut(function() {
									$(this).closest('.floating').andSelf().remove();
								});
						}
					})
				.end()

				.bind('submit', function() {
					var msg = $(this).find('textarea').val();
					if (msg.length == 0) { return false; }			
				})
				
				.bind('ajax:loading', function() {
					var $this = $(this),
						$textarea = $this.find('textarea#posting_message_body'),
						$thread = $this.closest('.wave_conversation').find('.thread ul.messages');

					$thread.append($("<li><div class='posting posting_message sent'>" + $textarea.val() + "</div></li>"));
					// $thread[0].scrollTop = $thread[0].scrollHeight;
					$thread.scrollTo('max', 200);
					$textarea.val('');
				})
			.end()

			.find('.thread')
				.each(function(idx, thread) {
					thread.scrollTop = thread.scrollHeight;
				});
	}
	
})(jQuery);

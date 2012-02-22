(function($) {
	
	$.fn.chat = function() {

		var $this = $(this), // wave_conversation	
			pusher = new Pusher('064cfff6a7f7e44b07ae'),
			channelId = $this.attr('id'),
			channel = pusher.subscribe(channelId);

		channel.bind('message', function(data) {
			$.get(data['url'], function(partial) {
				var $thread = $('.thread', data['dom_id']),
					$threadMessages = $thread.find('ul.messages');
				$threadMessages
					.append('<li>' + partial + '</li>')
					.find('.posting_message.received.unread').removeClass('unread');
				$thread.scrollTo('max', 90);
			});
		});

		$this
			.find('form')
				.find('button[type="submit"]')
					.hide()
				.end()

				.find('.message-input')
					.show()
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

				.bind('ajax:beforeSend', function() {
					var $this = $(this),
						$textarea = $this.find('textarea#posting_message_body'),
						$thread = $this.closest('.wave_conversation').find('.thread'),
						$threadMessages = $thread.find('ul.messages');

					$threadMessages					
						.append($("<li><div class='posting posting_message sent'>" + $textarea.val() + "</div></li>"))
						.find('.posting_message.received.unread').removeClass('unread');
					$thread.scrollTo('max', 90);
					$textarea.val('');
				})
			.end()

			.find('.thread')
				.each(function(idx, thread) {
					thread.scrollTop = thread.scrollHeight;
				});
	}
	
})(jQuery);

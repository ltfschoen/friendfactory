(function($) {

	var $trigger;
	var pusher = new Pusher('064cfff6a7f7e44b07ae');	
					
	var methods = {
		
		init: function() {
			
			return this.each(function() {

				$this = $(this);  // .postcard
				
				var channel_id = $this.attr('id');
				var channel = pusher.subscribe(channel_id);
				channel.bind('message', function(data) {
					$.get(data['url'], function(partial) {
						var threadDiv = $('.thread', data['dom_id']).append(partial)[0];
						threadDiv.scrollTop = threadDiv.scrollHeight;				
					});
				});

				$this
					.find('.thread')
						.each(function(idx, thread) {
							thread.scrollTop = thread.scrollHeight;
						})
					.end()
					
					.find('a.close')
						.click(function(event) {
							event.preventDefault();
							$(event.target).closest('.postcard')
								.fadeOut(function() {
									$(this).closest('.floating').andSelf().remove();
								});
						})
					.end()

					.find('form')
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
						
						.find('button[type="submit"]')
							.button({ icons: { primary: 'ui-icon-check' }})
						.end()
					
						.bind('ajax:loading', function() {
							$(this).find('.franking').fadeIn();
							$(this).find('button[type="submit"]').button('disable');
						})
						
						.bind('ajax:success', function(xhr, data, status) {
							$this = $(this);
							$this.find('.delivered').fadeIn();							
							setTimeout(function() {
								$this
									.find('.franking, .delivered').fadeOut().end()
									.find('textarea').val(''); }, 800);
						})
		
						.bind('ajax:complete', function() {
							$this = $(this);
							$this.find('textarea').focus();
							var threadDiv = $this.find('.thread')[0];
							threadDiv.scrollTop = threadDiv.scrollHeight;
							setTimeout(function() { $this.find('button[type="submit"]').button('enable'); }, 800);
						})
												
						.bind('submit', function() {
							var msg = $(this).find('textarea').val();
							if (msg.length == 0) { return false; }			
						})

						.bind('ajax:failure', function() {
							alert("Couldn't send your message. Try again or Cancel.");
						});		
			}) // each			
		}, // init
		
		
		overlay : function() {
			
			var $postcard = $('#postcard');
			var $sender = $('body').attr('data-first_name');
						
			return this.each(function() {
				$this = $(this); // a.message	
				
				$this.click(function(event) {
					$trigger = $(this);
				})				
				.overlay({
					top: '30%',
			      	target: '#postcard',
			      	close: '.button.cancel',
					mask: { color: '#666', opacity: 0.5 },
			
			      	onBeforeLoad: function(event) {
			        	var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
			        	var $receiver = $polaroid.find('.front.face .username').text();
						var actionUrl = encodeURI('/wave/profiles/' + $polaroid.data('profile_id') + '/messages');
						
			        	$postcard
							.find('form').attr('action', actionUrl).end()
							.find('textarea').val('').end()
							.find('.thread')
								.text('')
								.load('/wave/profiles/' + $polaroid.data('profile_id') + '/conversation',
									function() {
										var threadDiv = $postcard.find('.thread')[0];
										threadDiv.scrollTop = threadDiv.scrollHeight;
									})
							.end()
							.find('.franking, .delivered').hide().end()
							.find('button[type="submit"]').button('enable').end();
							// .find('#posting_message_profile_id').val($polaroid.data('profile_id'));
												
			        	var address = '<p><span class="profile">' + $receiver + '</span></p><p>From ' + $sender + '</p>';
			        	$postcard.find('.address').html(address);        
			        	$postcard.find('#receiver_avatar_image')
							.attr('src', $polaroid.find('img.polaroid').attr('src'));        
			      	}, // onBeforeLoad
				
					onLoad:function(event) {
						var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
						$('textarea', $postcard).focus();
			      	} // onLoad
			
			  	}); // overlay
			}); //each
			
		}, // init
		
		trigger : function() {
			return $trigger
		}
	}; // methods

				
	$.fn.postcard = function(method) {
		if (methods[method]) {
      		return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else if (!method) {
      		return methods.init.apply(this, arguments);
		} // if
	}; // fn.postcard
	
})(jQuery);

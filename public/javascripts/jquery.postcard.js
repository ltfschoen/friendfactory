(function($) {

	var $trigger;
					
	var methods = {
		init: function() {
			
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
			
			        	$postcard
							.find('textarea').val('').end()
							.find('.thread')
								.text('')
								.load('/profile/' + $polaroid.data('profile_id') + '/conversation',
									function() {
										var threadDiv = $postcard.find('.thread')[0];
										threadDiv.scrollTop = threadDiv.scrollHeight;
									})
							.end()
							.find('.franking, .delivered').hide().end()
							.find('button[type="submit"]').button('enable').end()
							.find('#posting_message_profile_id').val($polaroid.data('profile_id'));
												
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

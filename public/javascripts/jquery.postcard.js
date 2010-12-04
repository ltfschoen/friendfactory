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

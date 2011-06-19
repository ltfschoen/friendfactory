jQuery(function($) {

	var $ticket = $('#new_event_overlay');

	function updateMap(address, callback) {
		var params = encodeURIComponent('location[address]=' + address);
		$.get('/locations/geocode', params, function(resp) {
			if (resp) {
				$('div.map', $ticket).html(
					'<a href="' + resp['link_url'] + '" target="_blank"><img src="' + resp['map_url'] + '" class="map"></a>');
				
				$ticket
					// .find('#wave_event_location_address')
					// 	.val(resp['address'])
					// .end()

					.find('#wave_event_location_city')
						.val(resp['city'])
					.end()

					.find('#wave_event_location_state')
						.val(resp['state'])
					.end()
					
					.find('#wave_event_location_lat')
						.val(resp['lat'])
					.end()
					
					.find('#wave_event_location_lng')
						.val(resp['lng'])
					.end()
			}
		}, 'json')
	}

	$('form.new_wave_event', '.nav-content')
		.buttonize()
		
		.live('ajax:loading', function() {
			var $address = $('#wave_event_location_address');
			$(this).find('.button-bar').fadeTo('fast', 0.0);
			
			if (($('div.map img').length == 0) && ($address.val().length > 0)) {
				updateMap($address.val());
			}
		})
		
		.live('ajax:complete', function() {
			$(this).find('.button-bar').fadeTo('fast', 1.0);
		})
		
		.find('#wave_event_location_address')
			.blur(function() {
				updateMap($(this).val());
			})
		.end()
		
		.find('input.date')
			.datepicker({ dateFormat: 'DD, MM d, yy' })
		.end()		

		.find('button.cancel')
			.bind('click', function(event) {
				event.preventDefault();
				$(this).hideNavContent();
			});

	
	$('.nav-content').bind('reset', function(event) {
		event.preventDefault();
		event.target.reset();
		$(event.target).find('textarea, input[type="text"]').placehold();
	});

			
	$('a[rel]', 'ul.wave_events.nav')
		.bounceable()
		.shakeable()
		.click(function(event) {			
			var $this = $(this),
				$tab_content = $($this.attr('rel'));

			event.preventDefault();			

			if (!$this.closest('li').hasClass('current')) {
				$this.trigger('bounce')
					.closest('li')
					.addClass('current');					
				
				$tab_content					
					.css({ opacity: 0.0 })
					.prependTo('.tab_contents')
					.delay(1200)
					.slideDown(function() {
						$tab_content
							.find('form').trigger('reset').end()
							.fadeTo('fast', 1.0);
					});
					
			} else {
				$this.trigger('shake');				
			}	
		});
});

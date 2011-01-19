jQuery(function($) {

	var $trigger;
	var $ticket = $('#new_event_overlay');
	
	function updateMap(address, callback) {
		var params = encodeURIComponent('location[address]=' + address);
		$.get('/locations/geocode', params, function(resp) {
			if (resp) {
				console.dir(resp);
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
	
	$('li:eq(0) a', 'ul.wave.event.nav')
		.overlay({
			top: '12%',
			mask: { color: '#000', opacity: 0.3 },
			onBeforeLoad: function(event) {
				var $ticket = $('#new_event_overlay');
				$ticket.find('form')[0].reset();
				$ticket
					.find('button[type="submit"]')
						.button('enable')
					.end()
					.find('input.date')
						.datepicker('setDate', new Date())
					.end()
					
				$trigger = event.target.getTrigger();
			},
			onLoad: function(event) {}
		});

	// $('.ticket-container > .ticket').click(function(event) {
	// 	$(this).closest('.ticket').toggleClass('flipped');
	// });
		
	$ticket
		.find('form')
			.bind('ajax:loading', function() {
				$ticket.find('button[type="submit"]').button('disable');

				var $address = $('#wave_event_location_address');
				if (($('div.map img').length == 0) && ($address.val().length > 0)) {
					updateMap($address.val());
				}
			})
			.bind('ajax:success', function(xhr, data, status) {
				setTimeout(function(){ $trigger.overlay().close(); }, 700);
			})
			.bind('ajax:complete', function() {
				// $ticket.find('button[type="submit"]').button('enable');
			})
			
			.find('input.date')
				.datepicker({ dateFormat: 'DD, MM d, yy' })
			.end()
			
			.find('.button.cancel')
				.click(function(event){ event.preventDefault(); })
			.end()
			
			.find('#wave_event_location_address').blur(function() {
				updateMap($(this).val());
			});

});
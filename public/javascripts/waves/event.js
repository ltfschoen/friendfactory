jQuery(function($) {

	var $trigger;
	var $ticket = $('#new_event_overlay');
	
	$('li:eq(0) a', 'ul.wave.event.nav')
		.button({ icons: { primary: 'ui-icon-pencil' }})
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
				$ticket.find('button[type="submit"]').button('enable');
			},
			onLoad: function(event) {}
		});

	$('.ticket-container > .ticket').click(function(event) {
		$(this).closest('.ticket').toggleClass('flipped');
	});
		
	$ticket
		.find('form')
			.bind('ajax:loading', function(){
				$ticket.find('button[type="submit"]').button('disable');
			})
			.bind('ajax:success', function(xhr, data, status){
				setTimeout(function(){ $trigger.overlay().close(); }, 700);
			})
			.bind('ajax:complete', function(){})
			
			.find('input.date')
				.datepicker({ dateFormat: 'DD, MM d, yy' })
			.end()
			
			.find('.button.cancel')
				.click(function(event){ event.preventDefault(); })
			.end()
			
			.find('#wave_event_location_address').blur(function() {
				var $address = $(this);
				var params = encodeURIComponent('location[address]=' + $address.val());
				$.get('/locations/geocode', params, function(resp) {
					if (resp) {
						$address.val(resp['formatted_address']);
					}
				}, 'json')
			});

});
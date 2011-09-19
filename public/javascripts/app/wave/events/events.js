jQuery(function($) {

	var $ticket = $('#new_event_overlay');

	function updateMap(address, callback) {
		var params = encodeURIComponent('location[address]=' + address);
		$.get('/locations/geocode', params, function(resp) {			
			if (resp && resp['link_url'] !== undefined) {
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

		.live('ajax:before', function() {
			$(this).trigger('scrub.placehold');			
		})
		
		.live('ajax:beforeSend', function() {
			var $address = $('#wave_event_location_address');
			$(this).find('.button-bar button').addClass('ui-state-disabled');
			
			if (($('div.map img').length == 0) && ($address.val().length > 0)) {
				updateMap($address.val());
			}
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
				$(this).hideNavContent();
				return false;
			});

	
	$('.nav-content').bind('reset', function(event) {
		var $form = $('form', this);

		event.preventDefault();
		$form[0].reset();
		$form.find('textarea, input[type="text"]')
			.placehold()
			.removeClass('field-error')
			.end()
			.find('.button-bar button')
			.removeClass('ui-state-disabled');

		return $;
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
					.css({ opacity: 0.0, visibility: 'hidden' })					
					.prependTo('.tab_contents')
					.trigger('reset')
					.delay(1200)
					.slideDown(function() {
						$tab_content
							.css({ visibility: 'visible' })						
							.find('form').trigger('reset').end()
							.fadeTo('fast', 1.0)
					});
					
			} else {
				$this.trigger('shake');				
			}	
		});
});

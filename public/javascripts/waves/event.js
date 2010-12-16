jQuery(function($) {

	var $trigger;
	var $ticket = $('#new_event_overlay');
	
	$('li:eq(0) a', 'ul.wave.event.nav')
		.button({ icons: { primary: 'ui-icon-pencil' }})
		.overlay({
			top: '12%',
			mask: { color: '#501508', opacity: 0 },
			onBeforeLoad: function(event) {
				$trigger = event.target.getTrigger();
				$ticket.find('button[type="submit"]').button('enable');				
			},
			onLoad: function(event) {}
		});

	$('.ticket-container > .ticket').click(function(event) {
		$(this).closest('.ticket').toggleClass('flipped');
	});
		
	$ticket
		.find('.date')
			.datepicker()
		.end()
		.find('.button.cancel')
			.click(function(event){ event.preventDefault(); })
		.end()
		.find('form')
			.bind('ajax:loading', function(){
				$ticket.find('button[type="submit"]').button('disable');
			})
			.bind('ajax:success', function(xhr, data, status){
				setTimeout(function(){ $trigger.overlay().close(); }, 700);
			})
			.bind('ajax:complete', function(){})

});
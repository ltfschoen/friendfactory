jQuery(function($){

	var $trigger;
	var $ticket = $('#new_event_overlay');
	
	$('li:eq(0) a', 'ul.wave.nav')
		.button({ icons: { primary: 'ui-icon-clock' }})		
		.overlay({
			top: '20%',
			close: '.button.cancel',
			mask: { color: '#666', opacity: 0.5 },
			onBeforeLoad: function(event){
				$trigger = event.target.getTrigger();
				$ticket.find('button[type="submit"]').button('enable');				
			},
			onLoad: function(event){}
		});
		
	$ticket
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
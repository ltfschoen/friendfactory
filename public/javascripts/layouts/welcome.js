jQuery(function($) {

	// Initialize forms
	$('input, textarea').placeholder();

	// Ticker
	// setInterval(function(){
	// 	var obj = $('#stream .portrait').first()
	// 	obj.clone().appendTo('#container');
	// 	obj.animate({marginLeft: -35}, 500, function(){
	// 		obj.remove();
	// 	});
	// }, 2500);


	// Headshots
	$('div.headshot').headshot({ panes: { conversation: function(){} }});

	$('a.flip.icon[title]')
		.tooltip()
		.click(function(event) {
			return false;
			$(this).data('tooltip').getTip().hide();
		});


	// Badge
	$("#reuse_password").hide();

	$('input#user_email').change(function(event) {
		$.getJSON('/users/member', { email: $(event.target).val() }, function(data) {
			if (data['member'] !== false) {
				$("input#user_password_confirmation").hide();
				$("#reuse_password").find('span').text(data['member']).end().show();
			} else {
				$('input#user_password_confirmation').show();
				$("#reuse_password").hide();
			}
		});
	});


	// Forgotten password
	$('a.forgotten').click(function(event) {
		event.preventDefault();
		$('.dialog')
			.find('.spinner').css({ visibility: 'hidden' }).end()
			.find('input#cancel').attr('value', 'Cancel').end()
			.find('p:eq(0), input[type="submit"], input[name="email"]').show().end()
			.find('p:eq(1)').hide().end()
			.css({display: 'block'})
			.animate({
				marginTop: -100,
				opacity: 100
			}, 250);
		$('#mask').show();
	});

	$('.dialog #cancel').click(function() {
		$('.dialog').animate({
			opacity: 0,
			marginTop: 0
		}, 250);
		$('#mask').hide();
	});

	$('form#user_password_reset')
		.bind('ajax:beforeSend', function() {
			$(this).find('.spinner').css({ visibility: 'visible' });
		})
		.bind('ajax:complete', function(){
			$(this).find('.spinner').css({ visibility: 'hidden' });
		})
		.bind('ajax:success', function(data, status) {
			var $this = $(this);

			$this.find('p:eq(1)').text(status['message']).show();

			if (status['success']) {
				$this
					.find('input#cancel').attr('value', 'Close').end()
					.find('p:eq(0), input[type="submit"], input[name="email"]').hide();
			}
		});
});


jQuery(window).load(function() {
	setInterval(function() {
		$('.cssanimations #badge').addClass('animation');
		$('.no-cssanimations #badge').animate({
			marginTop: 310
		}, 1200, 'easeOutElastic');
	}, 900);
});
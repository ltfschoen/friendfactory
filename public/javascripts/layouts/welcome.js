jQuery(function($) {

  	// setInterval(function(){
  	// 	var obj = $('#stream .portrait').first()
  	// 	obj.clone().appendTo('#container');
  	// 	obj.animate({marginLeft: -35}, 500, function(){
  	// 		obj.remove();
  	// 	});
  	// }, 2500);

	$('div.headshot').headshot({ panes: { conversation: function(){} }});

	$('a.flip.icon[title]')
		.tooltip()
		.click(function() {
			$(this).data('tooltip').getTip().hide();
		});

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


	// Forgotten email dialog
	$('a.forgotten').click(function(event) {
		event.preventDefault();
		$('.dialog')
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
	setInterval(function(){
	  $('#badge').addClass('animation');
	}, 900);
});
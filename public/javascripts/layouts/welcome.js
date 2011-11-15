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

	$('.dialog #cancel').click(function() {
		$('.dialog').animate({
			opacity: 0,
			marginTop: 0
		}, 250);
		$('#mask').hide();
	});

	$('a.forgotten').click(function(event) {
		event.preventDefault();
		$('.dialog').css({display: 'block'}).animate({
			marginTop: -100,
			opacity: 100
		}, 250)
		$('#mask').show();
	});

});

jQuery(window).load(function() {
	setInterval(function(){
	  $('#badge').addClass('animation');
	}, 900);
});
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
});

jQuery(window).load(function() {
	setInterval(function(){
	  $('#badge').addClass('animation');
	}, 900);    
});
jQuery(function($) {
	$('div.headshot').headshot({ panes: { conversation: function(){} }});
	$('a.flip.icon[title]')
		.tooltip()
		.click(function() {
			$(this).data('tooltip').getTip().hide();
		});
});
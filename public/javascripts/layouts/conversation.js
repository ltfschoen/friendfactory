jQuery(window).load(function() {
	$('div.headshot').headshot({ pane: 'conversation', setFocus: false });
	
	$('a.conversations').bind('ajax:success', function (data, status) {
		var $this = $(this).closest('.datecell'),
			idx = $this.index();
			
		$this.closest('.datecell').replaceWith(status);
		$('.datecell').eq(idx).find('div.headshot').headshot({ pane: 'conversation', setFocus: false });
	});
});

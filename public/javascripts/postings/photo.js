jQuery(function($) {

	$('.tab_content#posting_photo')
		
		.find('input[type="file"]')
			.live('change', function(event) {
				$(event.target.form).submit();
			})
		.end()
		
		.find('form.edit_posting_photo button.cancel')
			.live('click', function(event) {
		        $(this).callRemote();
			})
		.end()
		
		.bind('reset', function(event) {
			var $this = $(this);
			var $target = $('a[rel="#' + $this.attr('id') +'"]', 'ul.wave.community.nav')

			$this.load($target.attr('href') + ' form', function(event) {
				$(this)
					.find('button.cancel, a.cancel')
						.button({ icons: { primary: 'ui-icon-close' }})
					.end()					
					.find('button[type="submit"]')
						.button({ icons: { primary: 'ui-icon-check' }})
					.end()					
					.find('textarea')
						.placehold()
					.end()
					.find('textarea', '.post_it.attachment')
						.textareaCount({ 'maxCharacterSize': 70 }, function(data){});
			});
		})
		.trigger('reset');
	
});

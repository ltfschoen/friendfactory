jQuery(function($) {

	$('.posting_link.' + $.getUserId())
		.find('p.description, a.title')
			.attr('contenteditable', true)

			.live('blur', function (event) {
				var $this = $(this),
					$posting = $this.closest('.posting_link'),
					params = {};

				if ($this.is('[contenteditable]')) {
					params[$this.attr('class')] = $this.html();
					$.ajax({
						type: 'put',
						url: '/postings/' + $posting.getId(),
						data: { posting: { resource_attributes: params }},
						dataType: 'json',
						success: function () {}
					});
				}
		});

	$('form#new_posting_text')
		.bind('open', function () {
			$(this)
				.find('textarea').attr('style', '').end()
				.find('.preview .body').html('');
			$.hideAllReactions();
		})

		.bind('close', function () {
			$.showAllReactions();
		});
	
});

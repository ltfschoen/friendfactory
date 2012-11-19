jQuery(function($) {

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

	$.posting = $.posting || {};

	$.posting.text = function (postings) {
		postings.filter('.' + $.getUserId())
			.find('a.edit')
				.click(function (event) {
					var $this = $(this),
						url = $this.attr('href'),
						$frame = $this.closest('.post_frame');

					event.preventDefault();
					$.get(url, function (data, status) {
						$frame.html(data);
						$frame.find('textarea').hashify();
					}, 'html');
				});
	};

});

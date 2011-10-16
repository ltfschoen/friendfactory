(function($) {
	$.fn.unpublishOverlay = function () {
		return this.each(function() {
			$(this).overlay({
				top: '35%',
				left: 'center',
				closeOnClick: true,
				closeOnEsc: true,
				load: false,
				onClose: function (event) {
					var url = this.getTrigger().attr('href'),
						originalTarget = (event.originalTarget || event.srcElement || event.originalEvent.target),
						ok = (originalTarget && $(originalTarget).hasClass('ok')) || false;
					if (ok) $.ajax({ type: 'delete', url: url, dataType: 'script' });
				}
			});
		});
	};
})(jQuery);

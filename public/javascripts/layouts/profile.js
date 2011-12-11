jQuery(function($) {

	$('input[type="text"], textarea').placeholder();

	$('input[name="user[emailable]"]').bind('ajax:before', function() {
		$(this).data('params', this.name + '=' + this.checked);
		return true;
	});

	$('form#new_posting_avatar').fileUploadUI({
		dropEffect: null,
		dropZone: $('.dropzone'),
		uploadTable: $('ul#upload_posting_avatar'),
		downloadTable: $('ul#upload_posting_avatar'),

		beforeSend: function (event, files, index, xhr, handler, callBack) {
			var pulseCycle = function() {
				$('ul#upload_posting_avatar img')
					.animate({ opacity: 0.6 }, 300)
					.animate({ opacity: 1.0 }, 300);
			};

			handler.pulseCycleId = setInterval(pulseCycle, 600);
			callBack();
		},

		onComplete: function (event, files, index, xhr, handler) {
			clearInterval(handler.pulseCycleId);
		},

        buildUploadRow: function (files, index, handler) {
			return;
        },

        buildDownloadRow: function (avatar, handler) {
			$('ul#upload_posting_avatar').empty();
            return $('<li><img src="' + avatar.url + '" height="190" width="190" title="' + avatar.title + '"></li>');
        }
    })

	.find('input#avatar_upload_submit').hide();

});

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

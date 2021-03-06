jQuery(function($) {

	$('input[type="text"], textarea').placeholder();

	$('input[name="personage[persona_attributes][emailable]"], input[name="personage[persona_attributes][featured]"]')
		.bind('ajax:before', function () {
			var $this = $(this);
			$this.data('params', this.name + '=' + this.checked + '&personage[persona_attributes][id]=' + $this.data('persona_id'));
			return true;
		});

	$('input[name="personage[state]"]')
		.bind('ajax:before', function() {
			$(this).data('params', this.name + '=' + (this.checked ? 'enable!' : 'disable!'));
			return true;
		})
		.bind('ajax:success', function(data, status) {
			if (status['state'] !== undefined) {
				document.location.reload(true);
			}
		});

	$('button[rel="#delete_profile_overlay"]').overlay();

	$('form#new_posting_avatar')
		.fileUploadUI({
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
				$('input#personage_persona_attributes_avatar_id').val(avatar.avatar_id);
				$('img.' + avatar.pid, '#sidebar').attr('src', avatar.url);
	            return $('<li><img src="' + avatar.url + '" height="190" width="190" title="' + avatar.title + '"></li>');
	        }
	    })

		.find('input#avatar_upload_submit').hide();

	$('form#new_posting_invitation')
		.bind('ajax:before', function () {
			var $this = $(this),
				eq = $this.find('input#li_eq').val();

			$this
				.find('.button-bar, input#posting_invitation_body').hide().end()
				.find('li:eq(' + eq + ') img.thumb').pulse();
		})

		.find('.button-bar, input#posting_invitation_body').hide().end()

		.find('a.new_posting_invitation, a.edit_posting_invitation')
			.click(function (event) {
				var $target = $(event.target),
					eq = $target.closest('li').prevAll('li').length,
					email = $target.attr('title'),
					url = $target.data('url'),
					method = $target.data('method');

				event.preventDefault();
				$target.closest('form')
					.attr('action', url)
					.find('input#li_eq').val(eq).end()
					.find('input[name="_method"]').attr('value', method).end()
					.find('input#posting_invitation_body').val(email).end()
					.find('p.instructions').hide().end()
					.find('.button-bar, input#posting_invitation_body').show().placeholder();
			});

});

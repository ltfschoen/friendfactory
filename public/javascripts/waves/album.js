jQuery(function($) {

	function renderPostingPhoto(photo) {
		var imgTag = '<div class="photo canvas"><img src="' + photo.image_path + '" class="photo small ';
		imgTag += (photo.horizontal ? 'h4x6"' : 'v4x6"') + '></div>';
		return '<div class="posting '+ photo.dom_id + '">' + imgTag + '</div>';
	}


	$('.posting_photos').masonry({
		singleMode: false,
		columnWidth: 1,
		itemSelector: 'li'
	});
	
	
	$('#wave_album.tab_content')
		.live('reset', function() {
			$(this)
				.find('ul.posting_photos').empty().end()
				.find('form')
					.css({ opacity: 1.0 })
					.show()
					.find('#wave_id').val('');
		})
		.trigger('reset');

	
	$('form.new_wave_album', '.tab_content')
		.buttonize({ text: true })
		
		.find('button.submit')
			.bind('click', function(event) {
				event.preventDefault();
			
				var $form = $(this).closest('form'),							
					publishId = $form.find('#publish_id').val(),
					albumId = $form.find('#wave_id').val();
			
				if (albumId !== '') {
					var url = '/waves/' + publishId + '/posting/wave_proxies',
						$tabContent = $form.closest('tab_content');
					
					$tabContent.fadeTo('fast', 0.0, function() {
						$tabContent.slideUp(800, 'easeOutBounce', function() {
							$tabContent.trigger('reset');
						});
					});
										
					$.post(url, { resource_id: albumId }, function(){}, 'script');
				}
			})
		.end()
		
		.find('button.cancel')
			.bind('click', function() {
				$(this).hideTabContent();
				return false;
			})
		.end()
		
		.fileUploadUI({
			dropEffect: null,
			dropZone: $('.dropzone'),
			uploadTable: $('.tab_content ul.posting_photos'),
			downloadTable: $('.tab_content ul.posting_photos'),

			buildUploadRow: function(files, index) {
				return $('<li><div class="pulse photo canvas"><img src="/images/friskyfactory/silhouette-q.gif" class="photo h4x6 small"></div></li>');
			},

			buildDownloadRow: function(photo) {
				return $('<li>' + renderPostingPhoto(photo) + '</li>');
			},

	        beforeSend: function (event, files, index, xhr, handler, callBack) {							
	            if (index === 0) {
	                files.uploadSequence = [];
	                files.uploadSequence.start = function (index) {
	                    var next = this[index];
	                    if (next) {
	                        next.apply(null, Array.prototype.slice.call(arguments, 1));
	                        this[index] = null;
						}
	                };
	            }

				(pulseCycle = function() {
					$('.no-cssanimations .tab_content ul.posting_photos .canvas.pulse')
						.animate({ opacity: 0.6 }, 300)
						.animate({ opacity: 1.0 }, 300, pulseCycle);
				})();
			
	            files.uploadSequence.push(callBack);
			
	            if (index + 1 === files.length) {
	                files.uploadSequence.start(0);
	            }
	        },

	        onComplete: function (event, files, index, xhr, handler) {
				var result = handler.parseResponse(xhr),					
					$form = $(handler.dropZone).closest('form');
			
				$('input#wave_id', $form).val(result.wave_id);
			
				if (result.proxy_id !== undefined) {
					$('input#proxy_id', $form).val(result.proxy_id);
				}

				// files.uploadSequence.start(index + 1);
				if (index === 0) {
					for (i = 1, j = files.length; i < j; i++) {
						files.uploadSequence.start(i);
					}
				}
	        },

	        onAbort: function (event, files, index, xhr, handler) {
	            handler.removeNode(handler.uploadRow);
	            files.uploadSequence[index] = null;
	            // files.uploadSequence.start(index + 1);
	        }
		});
	
});

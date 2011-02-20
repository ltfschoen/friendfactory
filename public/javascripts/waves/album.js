jQuery(function($) {

	function renderImgTag(photo) {
		var imgTag = '<div class="photo canvas"><img src="' + photo.image_path + '" class="photo small ';
		imgTag += photo.horizontal ? 'h4x6"' : 'v4x6"';
		return imgTag + '></div>';
	}
	
	
	function renderPostingPhoto(photo) {
		return '<div class="posting '+ photo.dom_id + '">' + renderImgTag(photo) + '</div>';
	}


	$('.photo.canvas', '.cssanimations .tab_content')
		.bind('pulse', function() {
			$(this).toggleClass('pulse');
		});

	$('.photo.canvas', '.no-cssanimations .tab_content')
		.bind('pulse', function() {
			var $this = $(this);
			
			if (!$this.hasClass('pulse')) {
				var worker = setInterval(function() {
					$this.fadeTo(300, 0.5).fadeTo(300, 1.0);				
				}, 600);
				
				$this
					.attr('data-worker', worker)
					.addClass('pulse');
				
			} else {
				clearInterval($this.attr('data-worker'));
				$this
					.removeAttr('data-worker')
					.removeClass('pulse');
			}
		});
	
	
	$('form.new_wave_album, form.edit_wave_album')
		.live('reset', function() {
			$(this)
				.fileUploadUI({
					dropEffect: null,
					uploadTable: $('.tab_content ul.posting_photos'),
					downloadTable: $('.tab_content ul.posting_photos'),

					buildUploadRow: function(files, index) {
						return $('<li><div class="pulse photo canvas"><img src="/images/friskyfactory/silhouette-q.gif" class="photo h4x6 small"></div></li>');
					},

					buildDownloadRow: function(photo) {
						return $('<li>' + renderPostingPhoto(photo) + '</li>');
					},

			        beforeSend: function (event, files, index, xhr, handler, callBack) {
						// $('.photo.canvas', handler.dropZone).hide();
							// .trigger('pulse');
							
			            if (index === 0) {
			                files.uploadSequence = [];
			                files.uploadSequence.start = function (index) {
			                    var next = this[index];
			                    if (next) {
			                        next.apply(null, Array.prototype.slice.call(arguments, 1));
			                        this[index] = null;
			                    } else {
									// $('.photo.canvas', handler.dropZone).show();
									// .trigger('pulse');
								}
			                };
			            }
			
			            files.uploadSequence.push(callBack);
						
			            if (index + 1 === files.length) {
			                files.uploadSequence.start(0);
			            }
			        },
			
			        onComplete: function (event, files, index, xhr, handler) {
						var result = handler.parseResponse(xhr);
						$('input#wave_id', handler.dropZone).val(result.wave_id);
						files.uploadSequence.start(index + 1);
			        },
			
			        onAbort: function (event, files, index, xhr, handler) {
			            handler.removeNode(handler.uploadRow);
			            files.uploadSequence[index] = null;
			            files.uploadSequence.start(index + 1);
			        }
				})
				.find('p.unobtrusive')
					.show();
		})
		.trigger('reset');
	
});

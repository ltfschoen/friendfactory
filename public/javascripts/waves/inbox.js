jQuery(function($) {

	$('.postcard', '.inbox')
		.postcard()
		.draggable({
			cancel: '.thread, textarea, button',
			stack: '.wave_conversation',
			drag: function(event, ui) {
				console.log(
					"position:" + ui.position.left + "," + ui.position.top,
					" offset:" + ui.offset.left + "," + ui.offset.top,
					" position():" + ui.helper.position().left + "," + ui.helper.position().top);
			},
			stop: function(event, ui) {
				var position = $(ui.helper).position();
				// console.log(event);
				// console.log(ui.helper);
				// console.log($(ui.helper).css('z-index'));
				$.Storage.set($(ui.helper).attr('id'), position.top + 'x' + position.left + 'x' + $(ui.helper).css('z-index'));
			}
		})
		.each(function(idx, postcard) {
			(function($this, left, top) {
				// alert(left + ',' + top);
				// $this.css({
				// 	left: left,
				// 	top: top
				// 	// position: 'absolute'
				// })
			})($(postcard), $(postcard).position().left, $(postcard).position().top);
			// var top = $(this).position().top;
			// var left = $(this).position().left;
			// console.dir(top);
			// console.dir(left);
			// $(this).css({
			// 	// left: left + 'px',
			// 	// top: '100px',
			// 	// position: 'fixed'
			// })
			// pos = $(this).position();
			// console.dir($(this).position().left + "," + $(this).position().top );
		})
		.mousedown(function(event) {
			$(this).topZIndex('.wave_conversation');
		});	
});

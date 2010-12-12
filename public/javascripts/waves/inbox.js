jQuery(function($) {

	$('.postcard', '.inbox')
		.draggable({
			cancel: '.thread, textarea, button',
			stack: '.wave_conversation',
			drag: function(event, ui) {
				// console.log(
				// 	"position:" + ui.position.left + "," + ui.position.top,
				// 	" offset:" + ui.offset.left + "," + ui.offset.top,
				// 	" position():" + ui.helper.position().left + "," + ui.helper.position().top);
			},
			stop: function(event, ui) {
				// var position = $(ui.helper).position();
				// $.Storage.set($(ui.helper).attr('id'), position.top + 'x' + position.left + 'x' + $(ui.helper).css('z-index'));
			}
		})
		
		.mousedown(function(event) {
			$(this).topZIndex('.wave_conversation');
		})
		
		.find('a.close')
			.attr('data-remote', 'true')
			.attr('data-method', 'put');

});

$(function(){
	$('.polaroid').find('.face-container:eq(1)').hide();
  $('.polaroid .front .buddy-bar a.flip').live('click', function(event){
    event.preventDefault();
		var $polaroid = $(this).closest('.polaroid');			
		$polaroid.data('current', $(this).attr('href'));
		
    $polaroid.flip({
			speed: 280,
      direction: 'lr',
      color: '#FFF',
      content: $polaroid.find('.face-container:hidden'),
      onEnd: function(){
				$polaroid.find('.buddy-bar a.flip').click(function(event){
					event.preventDefault();
					$polaroid.revertFlip();
				});

				$polaroid.find('.scrollable').scrollable({
					items: 'items',
					keyboard: false,
					next: '',
					prev: ''
				}).navigator();
			
       	$polaroid.find('.navi .' + $polaroid.data('current')).click();
      }
    });
  });
});

$(function(){
  $('.polaroid .front .buddy-bar a.flip').live('click', function(event){
    event.preventDefault();
		var $this = $(this), $polaroid = $this.closest('.polaroid');
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
				
       	$polaroid.find('.buddy-bar .' + $this.attr('href')).click();
      }
    });
  });
});

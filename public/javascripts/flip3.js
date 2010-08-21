$(function(){
  $('.front.face .buddy-bar a.flip').live('click', function(event){
    event.preventDefault();
		$this = $(this);
    $this.closest('.polaroid').flip({
			speed: 240,
      direction: 'lr',
      color: '#FFF',
      content: $('#polaroid-back_face'),
      onEnd: function(){
				$('.back.face .buddy-bar a.flip').click(function(event){
					event.preventDefault();
					$('#polaroid-front_face').revertFlip();
				});

				$('#polaroid-front_face .scrollable').scrollable({
					items: 'items',
					keyboard: false,
					next: '',
					prev: ''
				}).navigator({
					navi: "#polaroid-front_face .back.face .buddy-bar.primary",
					naviItem: 'a',
					activeClass: 'current'
				});
				
        $('#polaroid-front_face .back.face .buddy-bar .' + $this.attr('href')).click();
      }
    });          
  });

});

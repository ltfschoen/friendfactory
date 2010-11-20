jQuery(function($) {
  // $('.polaroid').draggable({ handle: '.gripper' })
	if ($.browser.safari) {
		$('.polaroid-container .polaroid .back').css('-webkit-transform', 'rotateY(180deg)');
	  $('.polaroid-container .polaroid .back .scrollable').scrollable({
	    items: 'items',
	    keyboard: false,
	    next: '',
	    prev: '',
	    onSeek: function(event, idx) {
	      if (idx == 1) {
	        $photoGrid = $(this.getRoot()).find('.photo-grid');
	        // $.getJSON(/profile/);
          // $photoGrid.children('img').eq(0).attr('src', "/system/images/449/thumb/adam-01.jpg");
          // $photoGrid.children('img').eq(1).attr('src', '/system/images/451/thumb/adam-03.jpg');
          // $photoGrid.children('img').eq(2).attr('src', '/system/images/452/thumb/adam-04.jpg');
          // $photoGrid.children('img').eq(3).attr('src', '/system/images/453/thumb/adam-05.jpg');
          // $photoGrid.children('img').eq(4).attr('src', '/system/images/454/thumb/adam-06.jpg');
          // $photoGrid.children('img').eq(5).attr('src', '/system/images/455/thumb/adam-08.jpg');
          // $photoGrid.children('img').eq(6).attr('src', '/system/images/456/thumb/adam-09.jpg');
          // $photoGrid.children('img').eq(7).attr('src', '/system/images/457/thumb/adam-10.jpg');
          // $photoGrid.children('img').eq(8).attr('src', '/system/images/458/thumb/adam-11.jpg');
          // $photoGrid.children('img').eq(9).attr('src', '/system/images/459/thumb/adam-12.jpg');
	      }
	    }
	  }).navigator();
          
	  $('.polaroid-container .polaroid .front .buddy-bar a.flip').click(function(event){
	    event.preventDefault();	
	    $(this).addClass('current').closest('.polaroid').toggleClass('flipped') // .find('.gripper').hide();
	  });

	  $('.polaroid-container .polaroid .back .buddy-bar a.flip').click(function(event){
	    event.preventDefault();	
	    $(this).closest('.polaroid').toggleClass('flipped') // .find('.gripper').hide();
	  });
    
	  $('.polaroid-container .polaroid').each(function(idx, polaroid) {
        polaroid.addEventListener('webkitTransitionEnd', function(event){
        var $polaroid = $(event.target);
        var $current = $polaroid.find('.front.face .buddy-bar .current')
        $polaroid.find('.back .buddy-bar .' + $current.attr('href')).click();
        // $polaroid.find('.back .gripper').show();       
        // if (!$polaroid.hasClass('flipped')) {
        //   $polaroid.find('.front .gripper').show();
        // }
        $current.removeClass('current');
      });
	  });
	
	} else {
		$('.polaroid-container .polaroid').find('.face-container:eq(1)').hide();
	  $('.polaroid-container .polaroid .front .buddy-bar a.flip').live('click', function(event){
	    event.preventDefault();
			var $polaroid = $(this).closest('.polaroid');			
			$polaroid.data('current', $(this).attr('href'));
			
	    $polaroid.flip({
				speed: 280,
	      direction: 'lr',
	      color: '#FFF',
	      content: $polaroid.find('.face-container:hidden'),
	      onEnd: function(){
					// $polaroid.draggable().find('.buddy-bar a.flip').click(function(event){
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
	}
});

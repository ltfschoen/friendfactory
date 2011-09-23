$(document).ready(function(){

	$('.float').draggable({
		start: function(){ $(this).find('.card').css('-webkit-transition', 'all 0s') },
		stop: function(){ $(this).find('.card').css('-webkit-transition', 'all 0.50s') }
	});

	$('.card_frame').toggle(function(){
		$(this).addClass('flip')
	}, function(){
		$(this).removeClass('flip')
	});
	$('.comments a').click(function(){
		var react = $('#reaction'),
			id = $(this).attr('id')
		react.addClass('rm');
		$('.rm').before('<div id="reaction" class="hide">Showing results for ID '+id+'</div>');
		$('.rm').hide(500, function(){
			$(this).remove();
		});
		$('#reaction').show(500)			
	});
	
	
	$('.portrait').click(function(){
		var card = $('.float'),
			id = $(this).attr('id'),
			src = $(this).find('img').attr('src'),
			win = $(window).height(),
			off = $(this).offset(),
			x = off.left,
			y = (win-200) < off.top ? (win-210) : off.top;
			
		
		card.fadeOut(250, function(){
			$('.float').removeClass('flip')
			card.css({
					top: y,
					left: x
				}).fadeIn(250)
			card.find('.face').attr('src', src);
		});			
	})
	$('.close').click(function(){
		$('.float').fadeOut(250);
	});
	
	$('#scroller ul li').click(function(){
		var type = $(this).attr('class')
		$('.new_post').slideUp(250);
		$('.new_post.'+type).slideDown(250);
	});
	
	$('input[value="Cancel"]').click(function(){
		$(this).parents('.new_post').slideUp(250);
	})
	
});
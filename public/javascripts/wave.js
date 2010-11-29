new function($) {
  $.fn.setCursorPosition = function(pos) {
    if ($(this).get(0).setSelectionRange) {
      $(this).get(0).setSelectionRange(pos, pos);
    } else if ($(this).get(0).createTextRange) {
      var range = $(this).get(0).createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
    }
  }
}(jQuery);

jQuery(document).ready(function($) {  

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');

	// Buttons
  $('button[type="submit"]').button({ icons: { primary: 'ui-icon-check' }});
  $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

  // Overlay Postcard
  var $postcard = $('#postcard');
  var $sender = $('body').attr('data-first_name');
  var $trigger;
  
  $('.polaroid a.message')
    .click(function(){ $trigger = $(this); })
    .overlay({
      top:'30%',
      target:'#postcard',
      close:'.button.cancel',
			mask: { color: '#666', opacity: 0.5 },
      onBeforeLoad:function(event){
        var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
        var $receiver = $polaroid.find('.front.face .username').text();
        $postcard
					.find('textarea').val('')
					.end()
					.find('.thread')
						.text('')
						.load('/profile/' + $polaroid.data('profile_id') + '/conversation',
							function(){
								var threadDiv = $postcard.find('.thread')[0];
								threadDiv.scrollTop = threadDiv.scrollHeight;
							})
					.end()
					.find('.franking, .delivered').hide()
					.end()
					.find('button[type="submit"]').button('enable')
					.end()
					.find('#posting_message_profile_id').val($polaroid.data('profile_id'));
        var address = '<p><span class="profile">' + $receiver + '</span></p><p>From ' + $sender + '</p>';
        $postcard.find('.address').html(address);        
        $postcard.find('#receiver_avatar_image').attr('src', $polaroid.find('img.polaroid').attr('src'));        
      },
      onLoad:function(event){
        var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
        $('textarea', $postcard).focus();
      }
  });

	$postcard
		.find('.button.cancel')
			.click(function(event){ event.preventDefault(); })
		.end()
		.find('form')
			.bind('ajax:loading', function(){
				$postcard.find('.franking').fadeIn();
				$(this).find('button[type="submit"]').button('disable');
			})
			.bind('ajax:success', function(xhr, data, status){
				$postcard.find('.delivered').fadeIn();
				setTimeout(function(){ $trigger.overlay().close(); }, 700);
			})
			.bind('ajax:complete', function(){
				setTimeout(function(){ $postcard.find('button[type="submit"]').button('enable'); }, 700);				
			})
			.bind('ajax:failure', function(){ alert("Couldn't send your message. Try again or Cancel."); });

	// Inbox Postcards
	$('.postcard').not('#postcard')
		.find('form')
			.bind('ajax:loading', function(){
				$(this).find('.franking').fadeIn();
				$(this).find('button[type="submit"]').button('disable');
			})
			.bind('ajax:success', function(xhr, data, status){
				$this = $(this);
				$this.find('.delivered').fadeIn();
				setTimeout(function(){
					$this
						.find('.franking, .delivered').fadeOut()
						.end()
						.find('textarea').val('')
						.end()
						.find('button[type="submit"]').button('enable');
				}, 700);
			})
			.bind('ajax:complete', function(){
				$(this).find('textarea').focus();
				var threadDiv = $this.find('.thread')[0];
				threadDiv.scrollTop = threadDiv.scrollHeight;
			});
			
	// Inbox Postcards and Polaroid Postcard
	$('.postcard')
		.find('form')
			.bind('submit', function(){
				var msg = $(this).find('textarea').val();
				if (msg.length == 0) { return false; }			
			});
	
	var $threads = $('.postcard').find('form .thread');
	$threads.each(function(idx, thread){
		thread.scrollTop = thread.scrollHeight;
	});

	// shared.js was here
	
	// comment.js was here
	
});

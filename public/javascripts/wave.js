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
  $('button[type=submit]').button({ icons: { primary: 'ui-icon-check' }});
  $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

  // Message Postcard
  var $postcard = $('#message-postcard');
  var $sender = $('body').attr('data-first_name');
  var $trigger;
  
  $('a.message')
    .click(function(){ $trigger = $(this); })
    .overlay({
      top:'30%',
      target:'#message-postcard',
      close:'.button.cancel',
      onBeforeLoad:function(event){
        var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
        var $receiver = $polaroid.find('.front.face .username').text();
        $postcard.find('.franking').hide();
        var msg = 'Hey ' + $receiver + ',\n\n';
        $('textarea', $postcard).val(msg + '\n\nSincerely,\n' + $sender).focus(); //.setCursorPosition(msg.length);
        var address = 'To: '+ $receiver + "<br/>From: " + $sender;
        $postcard.find('.address').html(address);        
        $postcard.find('#receiver_avatar_image').attr('src', $polaroid.find('img.polaroid').attr('src'));        
      },
      onLoad:function(event){
        var $polaroid = $(event.target.getTrigger()).closest('.polaroid');
        var $receiver = $polaroid.find('.front.face .username').text();
        $('textarea', $postcard).focus().setCursorPosition($receiver.length + 7);
      }
  });

  $postcard
    .find('.button.cancel')
      .click(function(event){ event.preventDefault(); })
    .end()
    .find('[type="submit"]')
      .click(function(event){ $postcard.find('.franking').fadeIn();
        // $this = $(this);
        // setTimeout(function(){ $this.closest('form').submit(); }, 700);
        // event.preventDefault();
      })
    .end()
    .find('form')
      .bind('ajax:success', function(xhr, data, status){
        $trigger.overlay().close();
      });
      
  // Tabs
  $('.wave.nav li:eq(0)').button({ icons: { primary: 'ui-icon-pencil' }});
  $('.wave.nav li:eq(1)').button({ icons: { primary: 'ui-icon-image' }})
  // $('#tabs li:eq(2)').button({ icons: { primary: 'ui-icon-video' }});
  // $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-comment' }});
  // $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-link' }});
  // $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-clock' }});
  // $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-signal' }});

  $('ul.wave.nav li').click(function() {
    if (!$(this).hasClass('current')) {
      $(this).addClass('current').siblings('li.current').removeClass('current');
      $($(this).find('a').attr('href')).show().siblings('.tab_content').hide();
      this.blur();
    }
    return false;
  });

  $('button.cancel', '.tab_content').click(function() {
    $(this).parents('.tab_content').hide().end().parents('form')[0].reset();
    $('ul.wave.nav li.current').removeClass('current');
    return false;
  });

  $('.tab_content.photo form').bind('ajax:before', function(event) {
    $(this).hide();
    $('#posting_photo_upload_spinner').show();
  });

	// Comment forms
  $('a.new_posting_comment').live('click', function(event) {
    event.preventDefault();
    $(this).hide().next('.comment-bubble').show();
  });

  $('.comment-bubble form').bind('ajax:before', function(event) {
    $(this).hide().next('.new_posting_comment_spinner').show();
  });
	
  $('form.new_posting_comment')
     .find('button.cancel').live('click', function(event) {
       event.preventDefault();
       $(this).closest('.comment-bubble').hide().prev('a.new_posting_comment').show();
    });
});

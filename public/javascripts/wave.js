jQuery(document).ready(function($) {
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');
	
  $('form.new_posting_comment')
    .find('textarea')
    .live('click', function() {
      $(this).height('3.6em').next().show().closest('table').find('img.avatar').show();
  		})
    .blur(function() {
      if ($(this).val() === $(this).attr('placeholder')) {
        $(this).height('1.2em').next().hide().closest('table').find('img.avatar').hide();
      }
    });

  $('.posting_message')
    .find('button.message_reply').button({ icons: { primary: 'ui-icon-mail-closed' }})
     .click(function(event) {
       $(this).css('visibility', 'hidden').closest('.posting_message').find('form.new_posting_message').show();
       event.preventDefault();
     })
    .end()
    .find('form.new_posting_message')
    .hide()
    .find('button.cancel').click(function(event) {
	     $(this).closest('form.new_posting_message').hide().reset().closest('.posting_message').find('button.message_reply').css('visibility', 'visible');
	     event.preventDefault();
     })
    .end()
    .submit(function(event) {
      var form = this;
      event.preventDefault();
      jQuery.ajax({
        data: jQuery.param(jQuery(this).serializeArray()),
        dataType: 'script',
        cache: false,
        type: 'post',
        url: $(form).attr('action'),
        success: function() {
          $(form).hide().reset().closest('.posting_message').find('button.message_reply').css('visibility', 'visible');
        }
      });
    });
});

jQuery(document).ready(function($){
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');
  $('button[type=submit]').button({ icons: { primary: 'ui-icon-check' }});
  $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});
	
  $('form.new_posting_comment')
    .find('textarea').live('focus', function(){
      $(this).height('3.6em').siblings().show().closest('table').find('img.avatar').show();
  	}).end()
		.find('button.cancel').live('click', function(event){
			event.preventDefault();
			$(this).hide()				
			.closest('form').reset().end()
			.siblings('textarea').height('1.2em').placeholder({ className: 'placeholder' }).end()
			.siblings('button').hide().end()
			.closest('table').find('img.avatar').hide()
    });

	$('form.new_posting_comment').live('submit', function(event){
	    event.preventDefault();
	    FF.scrubPlaceholders(this);

	    if ($(this).find('textarea').val().length > 0) {
				var action = $(this).attr('action');
	      $.ajax({
	        data: jQuery.param(jQuery(this).serializeArray()),
	        dataType: 'script',
	        type: 'post',
	        url: action,
	        success: function(response, status) {
	        }
	      });
	    }
	
	    $(this).reset()
	    .find('button').hide().end()
	    .find('textarea').height('1.2em').placeholder({ className: 'placeholder' }).end()
	    .closest('table').find('img.avatar').hide();
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

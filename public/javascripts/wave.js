jQuery(document).ready(function($){

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');
	
	// Buttons
  $('button[type=submit]').button({ icons: { primary: 'ui-icon-check' }});
  $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

  $('#tabs li:eq(0)').button({ icons: { primary: 'ui-icon-pencil' }});
  $('#tabs li:eq(1)').button({ icons: { primary: 'ui-icon-image' }})
  $('#tabs li:eq(2)').button({ icons: { primary: 'ui-icon-video' }});
  // $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-comment' }});
  $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-link' }});
  // $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-clock' }});
  // $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-signal' }});

	// Tabs and tab content
  $('ul#tabs li').click(function() {
    if (!$(this).hasClass('current')) {
      $(this).addClass('current').siblings('li.current').removeClass('current');
      $($(this).find('a').attr('href')).show().siblings('.tab_content').hide();
      this.blur();
    }
    return false;
  });

  $('button.cancel', '.tab_content').click(function() {
    $(this).parents('.tab_content').hide().end().parents('form')[0].reset();
    $('ul#tabs li.current').removeClass('current');
    return false;
  });

  $('.tab_content form').bind('ajax:complete', function(event) {
    // this.reset();
    // $(this).closest('.tab_content').hide();
    // $('ul#tabs li.current').removeClass('current');    
  });

  // Video form
  // $('#video.tab_content form').submit(function(event){
  //   event.preventDefault()
  //   FF.scrubPlaceholders(this);
  //   jQuery.ajax({
  //     data: jQuery.param(jQuery(this).serializeArray()),
  //     dataType: 'script',
  //     cache: false,
  //     type: 'post',
  //     url: $(this).attr('action'),
  //     success: function() {
  //       $('#video.tab_content form').reset().closest('.tab_content').hide();
  //       $('ul#tabs li.current').removeClass('current');
  //     }
  //   });      
  // });
	
  // Link form
  // $('#link.tab_content form').submit(function(event){
  //   event.preventDefault();
  //   FF.scrubPlaceholders(this);
  //   jQuery.ajax({
  //     data: jQuery.param(jQuery(this).serializeArray()),
  //     dataType: 'script',
  //     cache: false,
  //     type: 'post',
  //     url: $(this).attr('action')
  //   });      
  // });

	// Comment forms
  $('form.new_posting_comment')
    .find('textarea').live('focus', function() {
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

  $('form.new_posting_comment').live('submit', function(event) {
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

    this.reset();
    $(this)
      .find('button').hide().end()
      .find('textarea').height('1.2em').placeholder({ className: 'placeholder' }).end()
      .closest('table').find('img.avatar').hide();
  });

	// Message forms
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

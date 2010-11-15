jQuery(document).ready(function($){

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');
	
	// Buttons
  $('button[type=submit]').button({ icons: { primary: 'ui-icon-check' }});
  $('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

  $('.wave.nav li:eq(0)').button({ icons: { primary: 'ui-icon-pencil' }});
  $('.wave.nav li:eq(1)').button({ icons: { primary: 'ui-icon-image' }})
  // $('#tabs li:eq(2)').button({ icons: { primary: 'ui-icon-video' }});
  // $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-comment' }});
  // $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-link' }});
  // $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-clock' }});
  // $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-signal' }});

	// Tabs and their contents
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

jQuery(function($){

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

});

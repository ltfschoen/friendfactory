jQuery(document).ready(function($){
  $('.tab_content:first').hide();
  $('button[type=submit]').button({ icons: { primary: 'ui-icon-check' }});
  $('.tab_content button.cancel')
    .click(function(){
      $(this)
        .parents('.tab_content').hide()
        .parents('form').reset();
      $('ul#tabs li.current').removeClass('current');
      return false;
    });

  $('#tabs li:eq(0)').button({ icons: { primary: 'ui-icon-pencil' }});
  $('#tabs li:eq(1)').button({ icons: { primary: 'ui-icon-image' }})
  $('#tabs li:eq(2)').button({ icons: { primary: 'ui-icon-video' }});
  $('#tabs li:eq(3)').button({ icons: { primary: 'ui-icon-comment' }});
  $('#tabs li:eq(4)').button({ icons: { primary: 'ui-icon-link' }});
  $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-clock' }});
  $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-signal' }});

  $('ul#tabs li').click(function(){
    if (!$(this).hasClass('current')) {
      $(this)
        .addClass('current')
        .siblings('li.current')
        .removeClass('current');
      $($(this)
        .find('a')
        .attr('href'))
        .show()
        .siblings('div.tab_content')
        .hide();
      this.blur();
      return false;
    }
  });
});

jQuery(document).ready(function($){
  $('.tab_content').hide();
});

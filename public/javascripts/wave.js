jQuery(document).ready(function($) {
	$(document).bind('connect', function(ev, data){
		var conn = new Strophe.Connection("http://bosh.metajack.im:5280/xmpp-httpbind");
		// var conn = new Strophe.Connection("http://friskyhands.com:5280/http-bind");
		conn.connect(data.jid, data.password, function(status) {
			if (status === Strophe.Status.CONNECTED) {
				$(document).trigger('connected');	
			} else if (status === Strophe.Status.DISCONNECTED) {
				$(document).trigger('disconnected')
			}
		});		
		Chat.connection = conn;
	});
	
	$(document).bind('connected', function(){
		FF.log('Connected!');
		Chat.connection.addHandler(Chat.handlePong, null, "iq", null, "ping1");
		var domain = Strophe.getDomainFromJid(Chat.connection.jid);
		Chat.ping(domain);
	});

	$(document).bind('disconnected', function(){
		$('#log').append('Disconnected!');
		Chat.connection = null;
	});	
});

jQuery(document).ready(function($){
	$(document).trigger('connect', {
		// jid: 'mjbamford@jabber.rootbash.com',
		// password: ''
		// jid: 'mjbamford@jabber.co.nz',
		// password: ''
		jid: 'mjbamford@friskyhands.com',
		password: '' // use extended internet password
	});
});

jQuery(document).ready(function($){
	$('input[placeholder], textarea[placeholder]')
		.placeholder({ className: 'placeholder' })
		.addClass('placeholder');
	
  $('form.new_posting_comment')
    .find('textarea')
    .keypress(function(){
      $(this)
        .height('3.6em')
        .next().show()
        .closest('table')
        .find('img.avatar').show();
		})
    .blur(function(){
      if ($(this).val() === $(this).attr('placeholder')) {
        $(this)
          .height('1.2em')
          .next().hide()
          .closest('table').find('img.avatar').hide();
      }
    });
});

jQuery(document).ready(function($){		
  $('.tab_content:first').hide();
  $('button[type=submit]')
    .button({ icons: { primary: 'ui-icon-check' }});

  $('button.cancel')
    .button({ icons: { primary: 'ui-icon-close' }})
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
  $('#tabs li:eq(4)').button({ icons: { primary: 'ui-icon-star' }});
  $('#tabs li:eq(5)').button({ icons: { primary: 'ui-icon-link' }});
  $('#tabs li:eq(6)').button({ icons: { primary: 'ui-icon-clock' }});
  $('#tabs li:eq(7)').button({ icons: { primary: 'ui-icon-signal' }});
  
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

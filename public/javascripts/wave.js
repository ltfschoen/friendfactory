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

jQuery(document).ready(function($) {
  $('.posting_message')
    .find('button.message_reply').button({ icons: { primary: 'ui-icon-mail-closed' }})
      .click(function(event) {
        $(this)
          .css('visibility', 'hidden').closest('.posting_message').find('form.new_posting_message').show();
          event.preventDefault();
      })
    .end()
    .find('form.new_posting_message')
      .hide()
      .find('button.cancel')
        .click(function(event) {
          $(this)
            .closest('form.new_posting_message').hide().reset()
            .closest('.posting_message')
            .find('button.message_reply').css('visibility', 'visible');
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
            $(form).hide().reset().closest('.posting_message')
              .find('button.message_reply')
                .css('visibility', 'visible');
          }
        });
      });
});


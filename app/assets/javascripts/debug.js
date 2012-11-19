jQuery.fn.log = function (msg) {
    console.log("%s: %o", msg, this);
    return this;
};

var PusherEvent = {
  log: function(message, avatar) {
    message = '<p>' + message
    if (avatar) {
      // message = message + avatar.id + avatar.image_file_name
    }
    message = message + '</p>'
    $('#events').prepend(message);
  }
};

var FF = {	
	inspect: function(obj){
		var str = ''; 
		for (var i in obj) {
			str += (i + "='" + obj[i] + "',");
		}
		return str
	},

	log: function(message){
		(function($) {
			$('#log').append("<p>" + message + "</p>");
		})(jQuery);	
	}
};

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

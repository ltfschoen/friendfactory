jQuery.fn.log = function (msg) {
    console.log("%s: %o", msg, this);
    return this;
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
}
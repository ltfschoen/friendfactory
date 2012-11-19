(function($) {
	$.fn.countchars = function(options, fn) {
		
		var defaults = {
			maxCharacters = 130
		};
		
		var options = $.extend(defaults, options);
		
		$(this) = $this;		
		$this.bind('keyup.ff'), function(event){
			countChars()
		});
		
		function countChars() {
			
		}
		
	};
})(jQuery);
//= require modernizr
//= require jquery-ui/1.8.16/jquery-ui.custom.min
//= require jquery.flip
//= require jquery.scrollTo-1.4.2-min
//= require jquery.chat.js
//= require jquery.headshot
//= require jquery.effects
//= require jquery_ujs
//= require application
//= require layouts/shared/sidebar
//= require_self

jQuery(window).load(function() {

	var callback = function ($headshot) {
		var $container = $headshot.closest('.headshot-container');
		$container.fadeTo('slow', 0.0, function () {
			$container.animate({ width: 0 }, 'fast', function () {
				$container.remove();
			});
		});
		return true;
	};

	$('div.headshot').headshot({ pane: 'conversation', setFocus: false, beforeClose: callback });

});

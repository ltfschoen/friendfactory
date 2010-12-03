if (/chrome/.test(navigator.userAgent.toLowerCase())){
  jQuery.browser.chrome = true;
  jQuery.browser.safari = false;
}

var FF = {	
	scrubPlaceholders: function(form) {
	  $(form).children('input[type=text], textarea').each(function(child){
      if ($(this).val().toLowerCase() === $(this).attr('placeholder').toLowerCase()) {
        $(this).val('');
	    }
		});
	}
};

jQuery(document).ready(function($) {
  $('button.cancel, a.cancel').button({ icons: { primary: 'ui-icon-close' }});
});

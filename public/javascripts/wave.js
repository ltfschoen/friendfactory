jQuery(document).ready(function($) {  

	// Placeholders
	$('input[placeholder], textarea[placeholder]').placeholder({ className: 'placeholder' }).addClass('placeholder');

	// Buttons
	$('button[type="submit"]').button({ icons: { primary: 'ui-icon-check' }});
	$('button.cancel').button({ icons: { primary: 'ui-icon-close' }});

	// Set up polaroid button to messaging
	$('a.message', '.polaroid').postcard();

	// Post-its
	$('a.profile[rel]', '.post_it')
		.overlay({
			top:'30%',
			mask: { color: '#666', opacity: 0.5 },			
			onBeforeLoad: function() {
				var wrap = this.getOverlay().find('.polaroid-wrap');
				wrap.load(this.getTrigger().attr('href'));
			}
		});
	
	// shared.js was here	
	// comment.js was here
	
});

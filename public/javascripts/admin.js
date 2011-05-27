jQuery(function($) {
	
	function newFileField(seq) {
		return $(
'<div class="tr asset"><div class="td silhouette"><img alt="Silhouette-q" height="32" src="/images/friskyfactory/silhouette-q.gif" width="32"></div><div class="td"><input id="site_assets_attributes_'+ seq + '_name" name="site[assets_attributes][' + seq + '][name]" placeholder="variable" size="30" type="text"><input id="site_assets_attributes_' + seq + '_asset" name="site[assets_attributes][' + seq + '][asset]" type="file"></div><div class="td">&nbsp;</div></div>');
	}
	
	$('.admin.invitation')
		.buttonize()
		
		.find('form')
			.bind('ajax:before', function() {
				$(this).find('.spinner').css({ 'visibility': 'visible' });
			})
		
			.bind('ajax:success', function(event, status) {
				var success = status['updated'];
				$(this).find('.spinner').css({ 'visibility': 'hidden' });
			})
		
			.find("select[name='posting_invitation[state]']")
				.change(function() {
					$(this).closest('form').trigger('submit');
				});
	
	$('.admin.site')
		.buttonize({ text: true })
		
		.find('input[type="file"]')
			.bind('change', function() {
				var $this = $(this),
					$tr = $this.closest('.tr.asset'),
					seq = $tr.prevAll('.tr.asset').andSelf().length;
				
				$tr.after(newFileField(seq));
			});

});

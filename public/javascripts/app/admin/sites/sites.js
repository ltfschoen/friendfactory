jQuery(function($) {
	
	function newFileField(seq) {
return $(
'<div class="tr asset image"><div class="td silhouette"><img alt="Silhouette-q" height="32" src="/images/friskyfactory/silhouette-q.gif" width="32"></div><div class="td"><input id="site_images_attributes_'+ seq + '_name" name="site[images_attributes][' + seq + '][name]" placeholder="name" type="text"><input id="site_images_attributes_' + seq + '_asset" name="site[images_attributes][' + seq + '][asset]" type="file"></div><div class="td">&nbsp;</div></div>');
	}
	
	function newConstantField(seq) {
return $('<div class="tr asset constant"><div class="td"><input id="site_constants_attributes_'+ seq + '_name" name="site[constants_attributes][' + seq + '][name]" placeholder="name" type="text"></div><div class="td"><input id="site_constants_attributes_'+ seq + '_value" name="site[constants_attributes][' + seq + '][value]" placeholder="value" type="text"></div><div class="td">&nbsp;</div></div>');
	}
	
	$('.admin.site')
		.buttonize({ text: true })
		
		.find('.tr.asset.image input[type="file"]')
			.live('change', function() {
				var $this = $(this),
					$tr = $this.closest('.tr.asset'),
					seq = $tr.prevAll('.tr.asset').andSelf().length;				
				$tr.after(newFileField(seq));
			})
		.end()
		
		.find('.tr.asset.constant input[type="text"]')
			.live('change', function() {
				var $this = $(this),
					$other = $this.closest('.td').siblings().find('input[type="text"]'),
					$tr = $this.closest('.tr.asset'),
					seq = $tr.prevAll('.tr.asset').andSelf().length;
				
				if ($this.val().length > 0 && $other.val().length > 0) {
					$tr.after(newConstantField(seq));
				}
			});
});

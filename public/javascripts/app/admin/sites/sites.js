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
			})
		.end()

		.find('button#new_stylesheet')
			.click(function(event) {
				var $this = $(this),
					$fields = $this.prev('.fields:last'),
					idx = $this.prevAll('.fields').length,
					$css = $fields.find('textarea.stylesheet_css'),
										
					nextIdx = function ($that, attr) {
						var $this = $that,
							value = $this.attr(attr),
							nextValue;
							
						if (value !== undefined) {
							nextValue = value.replace(/(\[|_)\d{1,}(\]|_)/, "$1" + idx + "$2");
							$this.attr(attr, nextValue);
						}
						return $this;					
					};

				event.preventDefault();
				if ($css.val().length > 0) {
					$fields.clone()
						.find('input, textarea')
							.val('')
							.each(function() { nextIdx(nextIdx($(this), 'id'), 'name'); })
						.end()
						.find('label')
							.each(function() { nextIdx($(this), 'for'); })
						.end()
						.insertAfter('.fields:last');
				} else {
					$css.shake();
				}
			})
		.end()
				
		.find('form.new_site, form.edit_site').submit(function(event) {
			var $controllerName;

			$controllerName = $('input.stylesheet_controller_name')
				.filter(function() { return this.value === ''; });

			if ($controllerName.length > 1) {
				event.preventDefault();
				$controllerName.shake();
			}
		});
});

jQuery(function($) {

	$('body.admin.sites')
		.find('.tr.asset.image input[type="file"]')
			.live('change', function () {
				var $this = $(this),
					$tr = $this.closest('.tr.asset'),
					seq = $tr.prevAll('.tr.asset').andSelf().length,
					$html;

				$html = $('#file-template').tmpl({ seq: seq });
				$tr.after($html);
			})
		.end()

		.find('button.add.asset')
			.live('click', function (event) {
				var $this = $(this),
					$tr = $this.closest('.tr.asset'),
					seq = $tr.siblings('.tr.asset').andSelf().length,
					type,
					$html;

				event.preventDefault();
				type = $.grep($tr.attr('class').split(/\s+/), function (className) {
					return (className === 'constant') || (className === 'text');
				}).toString();

				$html = $('#asset-template').tmpl({ seq: seq, type: type });
				$tr.after($html);
				$this.remove();
			})
		.end()

		.find('button#new_domain')
			.live('click', function (event) {
				var $this = $(this),
					domainSeq = $this.prevAll('.biometric_domain').length,
					$html;

				event.preventDefault();
				$html = $('#biometric_domain-template').tmpl({ domainSeq: domainSeq });
				$html.insertBefore($this);
			})
		.end()

		.find('button#new_domain_value')
			.live('click', function (event) {
				var $this = $(this),
					domainSeq = $this.closest('.biometric_domain').prevAll('.biometric_domain').length,
					$html;

				event.preventDefault();
				$html = $('#domain_value-template').tmpl({ domainSeq: domainSeq });
				$html.insertBefore($this);
			})
		.end()

		.find('button#new_stylesheet')
			.click(function (event) {
				var $this = $(this),
					seq = $this.prevAll('.stylesheet').length,
					$html;

				event.preventDefault();
				$html = $('#stylesheet-template').tmpl({ seq: seq });
				$this.before($html)
			})
		.end()
				
		.find('form.new_site, form.edit_site').submit(function (event) {
			var $controllerName;

			$controllerName = $('input.stylesheet_controller_name').filter(function () { 
				return this.value === '';
			});

			if ($controllerName.length > 1) {
				event.preventDefault();
				$controllerName.shake();
			}
		});

	$('body.admin.users.index')

		.find('input[name="user[default_personage_attributes][emailable_without_enabled_personage]"], input[name="user[admin]"]')
			.bind('ajax:before', function() {
				$(this).data('params', this.name + '=' + this.checked);
				return true;
			})
		.end()

		.find('input[name="user[state]"]')
			.bind('ajax:before', function() {
				$(this).data('params', this.name + '=' + (this.checked ? 'enable!' : 'disable!'));
				return true;
			});

	$('form.invitation_state')
		.bind('ajax:before', function() {
			$(this).find('.spinner').css({ 'visibility': 'visible' });
		})

		.bind('ajax:success', function(event, status) {
			var success = status['updated'];
			$(this).find('.spinner').css({ 'visibility': 'hidden' });
		})

		.find("select[name='invitation[state]']")
			.change(function() {
				$(this).closest('form').trigger('submit');
			});

});

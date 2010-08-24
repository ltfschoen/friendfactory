jQuery(function($){
	$('form.new_posting_chat').submit(function(event) {
    event.preventDefault();
		$this = $(this);
    if ($this.find('input[type=text]').val().length > 0) {
			var action = $this.attr('action');
      $.ajax({
        data: $.param($this.serializeArray()),
        dataType: 'script',
        type: 'post',
        url: action,
        success: function(response, status) {
					if (status == 'success') {
						$this.reset();
					}
				}
			});
		}
	});
});

jQuery(function($) {

	var $profile = $('.wave_profile.current_user'),
		profileId = $profile.data('profile_id');

	$profile
		.find('.signals')
			.load('/wave/profiles/' + profileId + '/signals')
		.end()
		
		.find('form')
			.bind('ajax:before', function(event) {
				$profile.find('.button-bar').hide();
			});
		
});

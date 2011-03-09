jQuery(function($) {

	$('<script>')
		.attr('src', 'http://www.youtube.com/player_api')
		.attr('type', 'text/javascript')
		.insertBefore('script:first');
		
		
	$('form.new_posting_video', '.tab_content')
		.buttonize()
		
		.find('button.cancel')
			.bind('click', function() {
				$(this).hideTabContent();
				return false;
			})
		.end()

});


function onYouTubePlayerAPIReady() {
	$('a', '.youtube_video_player').live('click', function(event) {
		event.preventDefault();
		$('img.youtube_thumb', this).fadeOut('slow');
		new YT.Player($(this).closest('.youtube_video_player').get(0), {
			height: '260',
			width: '400',
			videoId: getYouTubeVideoId($(this).attr('href')),
			playerVars: {
				'disablekb': 1,
				// 'controls': 0,
				'egm': 0 },
			events: {
				'onReady': onPlayerReady,
				'onStateChange': onPlayerStateChange,
				'onError': onPlayerError
			}
		});
	});	
}


function getYouTubeVideoId(url) {
	return url.match("[\\?&]v=([^&#]*)")[1];
}


function onPlayerReady(event) {
	$(event.target.a.parentNode).find('a').remove();
  	event.target.playVideo();
}

function onPlayerStateChange(event) {
  // if (event.data == YT.PlayerState.PLAYING && !done) {
  //   setTimeout(stopVideo, 6000);
  //   done = true;
  // }
}


function onPlayerError(event) {
	alert(event.data);
}


function stopVideo() {
  // player.stopVideo();
}


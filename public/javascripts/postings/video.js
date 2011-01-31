jQuery(function($) {
	$('<script>')
		.attr('src', 'http://www.youtube.com/player_api')
		.attr('type', 'text/javascript')
		.insertBefore('script:first');
		
	$('.tab_content#posting_video_upload')
		.find('button')
			.button({ text: false });
});

function onYouTubePlayerAPIReady() {
	$('a', '.youtube_video_player').live('click', function(event) {
		event.preventDefault();
		$('img.youtube_thumb', this).hide();
		new YT.Player($(this).closest('.youtube_video_player').get(0), {
			height: '260',
			width: '400',
			videoId: getYouTubeVideoId($(this).attr('href')),
			playerVars: { disablekb: 1 },
			events: {
				'onReady': onPlayerReady,
				'onStateChange': onPlayerStateChange
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

function stopVideo() {
  // player.stopVideo();
}


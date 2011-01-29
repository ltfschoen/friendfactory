jQuery(function($) {	
	$('<script>')
		.attr('src', 'http://www.youtube.com/player_api')
		.attr('type', 'text/javascript')
		.insertBefore('script:first');
});

// var player;
function onYouTubePlayerAPIReady() {
	$('.youtube_player').each(function() {
		new YT.Player(this, {
			height: '260',
			width: '400',
			videoId: $(this).attr('data-vid'),
			playerVars: { disablekb: 1 },
			events: {
				'onReady': onPlayerReady,
				'onStateChange': onPlayerStateChange
			}
		});

	});	
}

function onPlayerReady(event) {
  // event.target.playVideo();
}

// var done = false;
function onPlayerStateChange(event) {
  // if (event.data == YT.PlayerState.PLAYING && !done) {
  //   setTimeout(stopVideo, 6000);
  //   done = true;
  // }
}

function stopVideo() {
  // player.stopVideo();
}


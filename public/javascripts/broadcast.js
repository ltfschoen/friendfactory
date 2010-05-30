var PusherEvent = {
  log: function(message, avatar) {
    message = '<p>' + message
    if (avatar) {
      // message = message + avatar.id + avatar.image_file_name
    }
    message = message + '</p>'
    $('#events').prepend(message);
  }
};

jQuery(document).ready(function($) {
  var server = new Pusher('064cfff6a7f7e44b07ae', 'wave');
  server.bind('user-online', function(user) {
    var avatar_url;
    // if (user.avatar !== undefined) {
      // avatar_url = '/system/images/' + avatar.id + '/thumb/' + avatar.file_name
    // }
    PusherEvent.log(user.full_name + ' arrived', avatar);
  });
  server.bind('user-register', function(user) {
    PusherEvent.log(user.full_name + ' registered!');
  });
  server.bind('lurker-online', function(user) {
    PusherEvent.log('A lurker arrived');
  });
  server.bind('user-offline', function(user) {
    PusherEvent.log(user.full_name + ' logged out');
  });
});
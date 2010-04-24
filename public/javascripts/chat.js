var Chat = {
	connection: null,
	startTime: null,
	
	ping: function(to) {
		var thePing = $iq({
			to: to,
			type: "get",
			id: "ping1" }).c("ping", { xmlns: "urn:xmpp:ping" });
		FF.log("Sending ping to "+ to + ".");
		Chat.startTime = (new Date()).getTime();
		Chat.connection.send(thePing);
	},
	
	handlePong: function(iq) {
		var elapsed = (new Date()).getTime() - Chat.startTime;
		FF.log("Received pong from server in " + elapsed + "ms.");
		Chat.connection.disconnect();
		return false;
	}
};

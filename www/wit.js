var Wit = {
	
	init: function(token, callback) {
		cordova.exec(
			callback, // success callback with param
			function(err) { // error callback with param error
				callback(err);
			},
			'CDVWit', // plugin name
			'init', // method
			[token] // ['first parameter = wit token']
		);
	},
	
	toggleCaptureVoiceIntent: function() {
		cordova.exec(
			function () {}, // success callback with param
			function(err) {},
			'CDVWit', // plugin name
			'toggleCaptureVoiceIntent', // method
			[''] // no parameter
		);
	},
	
	version: function() {
		return "0.1.0"
	}
};

module.exports = Wit;
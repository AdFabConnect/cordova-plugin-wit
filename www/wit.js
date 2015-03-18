var Wit = {
	
	register: function(token, callback) {
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
	
	startRecord: function(callback) {
		cordova.exec(
			callback, // success callback with param
			function(err) { // error callback with param error
				callback(err);
			},
			'CDVWit', // plugin name
			'startRecord', // method
			[''] // no parameter
		);
	},
	
	stopRecord: function(callback) {
		cordova.exec(
			callback, // success callback with param
			function(err) { // error callback with param error
				callback(err);
			},
			'CDVWit', // plugin name
			'stopRecord', // method stop
			[''] // no parameter
		);
	},
	
	version: function() {
		return "0.1.0"
	}
};

module.exports = Wit;
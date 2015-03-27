cordova.define("fr.adfab.witcordova.WitCdv", function(require, exports, module) { var WitCdv = {
	devMode: false,
	mic: null,
	listening: false,

	load: function() {
		var p = new Promise(function (resolve, reject){
			var js = document.createElement("script");

			js.type = "text/javascript";
			js.src = "js/microphone.min.js";

			js.addEventListener('load', function() {
				resolve();
			}, false);

			document.body.appendChild(js);
		});

		return p;
	},

	_bindEvents: function(callback) {
		this.mic.onready = function () {
			callback({
				action: "witReady",
				value: "Microphone is ready to record"
			});
    }.bind(this);
    this.mic.onaudiostart = function () {
    	this.listening = false
			callback({
				action: "witDidStartRecording",
				value: "Recording started"
			});
    }.bind(this);
    this.mic.onaudioend = function () {
    	this.listening = false
			callback({
				action: "witDidStopRecording",
				value: "Recording stopped, processing started"
			});
    }.bind(this);
    this.mic.onresult = function (intent, entities) {
    	this.listening = false

    	if(entities) {
    		entities.intent = intent;
				callback({
					action: "intent",
					value: JSON.stringify(entities)
				});
			}else {
				callback({
					action: "intent",
					value: intent
				});
			}
    }.bind(this);
    this.mic.onerror = function (err) {
    	this.listening = false
			callback({
				action: "error",
				value: err
			});
    }.bind(this);
    this.mic.onconnecting = function () {
			callback({
				action: "connecting",
				value: "Microphone is connecting"
			});
    }.bind(this);
    this.mic.ondisconnected = function () {
			callback({
				action: "notconnecting",
				value: "Microphone is not connected"
			});
    }.bind(this);
	},
	
	init: function(token, callback) {
		if(cordova.platformId === "browser") {
			this.load()
				.then(function() {
					this.mic = new Wit.Microphone();
					this._bindEvents(callback);
      		this.mic.connect(token);
				}.bind(this));
		}else {
			cordova.exec(
				callback, // success callback with param
				function(err) { // error callback with param error
					callback(err);
				},
				'CDVWit', // plugin name
				'init', // method
				[token] // ['first parameter = wit token']
			);
		}
	},
	
	toggleCaptureVoiceIntent: function() {
		if(cordova.platformId === "browser") {
			if(this.listening) {
				this.mic.stop();
				this.listening = true;
			}else {
				this.mic.start();
				this.listening = true;
			}
		}else {
			cordova.exec(
				function () {}, // success callback with param
				function(err) {},
				'CDVWit', // plugin name
				'toggleCaptureVoiceIntent', // method
				[''] // no parameter
			);
		}
	},
	
	version: function() {
		return "0.1.0"
	}
};

module.exports = WitCdv;
});

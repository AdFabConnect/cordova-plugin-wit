var WitCdv = {
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
			var res = {
				action: "witReady",
				value: "Microphone is ready to record"
			};
			this.logs(res);
			callback(res);
    }.bind(this);

    this.mic.onaudiostart = function () {
    	this.listening = false
    	var res = {
				action: "witDidStartRecording",
				value: "Recording started"
			};
			this.logs(res);
			callback(res);
    }.bind(this);
    this.mic.onaudioend = function () {
    	this.listening = false
    	var res = {
				action: "witDidStopRecording",
				value: "Recording stopped, processing started"
			};
			this.logs(res);
			callback(res);
    }.bind(this);
    this.mic.onresult = function (intent, entities, outcomes) {
    	this.listening = false
    	var json = (typeof outcomes !== "undefined" && outcomes !== null) ? outcomes
    		: { "msg_body": "", "outcome": {"intent": "", "entities": {},"confidence": 0.274},"msg_id": ""};

    	var res = {
				action: "intent",
				value: json
			};
			this.logs(res);
			callback(res);
    }.bind(this);
    this.mic.onerror = function (err) {
    	this.listening = false
    	var res = {
				action: "error",
				value: err
			};
			this.logs(res);
			callback(res);
    }.bind(this);
    this.mic.onconnecting = function () {
    	var res = {
				action: "connecting",
				value: "Microphone is connecting"
			};
			this.logs(res);
			callback(res);
    }.bind(this);
    this.mic.ondisconnected = function () {
    	var res = {
				action: "notconnecting",
				value: "Microphone is not connected"
			};
			this.logs(res);
			callback(res);
    }.bind(this);
	},
	
	init: function(token, callback, debug) {
		this.debug = (debug) ? debug : false;

		if(this.debug) {
			this.showDebug();
		}

		if(cordova.platformId === "browser") {
			this.load()
				.then(function() {
					this.mic = new Wit.Microphone();
					this._bindEvents(callback);
      		this.mic.connect(token);
				}.bind(this));
		}else {
			cordova.exec(
				function(e) {
					this.logs(e);
					if(e.action === "intent") {
						e.value = JSON.parse(e.value);
					}
					callback(e);
				}.bind(this), // success callback with param
				function(err) { // error callback with param error
					callback(err);
				}.bind(this),
				'CDVWit', // plugin name
				'init', // method
				[token] // ['first parameter = wit token']
			);
		}
	},

	showDebug: function() {
		this.debuglogs = document.createElement("div");
		this.debuglogs.className = "debug-logs";
		this.debuglogs.style.position = 'absolute';
		this.debuglogs.style.padding = '10px 5%';
		this.debuglogs.style.color = '#fff';
		this.debuglogs.style.top = '5%';
		this.debuglogs.style.left = '5%';
		this.debuglogs.style.width = '90%';
		this.debuglogs.style.height = '50%';
		this.debuglogs.style.borderBottom = '2px solid rgba(12, 99, 238, .8)';
		this.debuglogs.style.backgroundColor = 'rgba(56, 126, 245, 0.8)';
		this.debuglogs.style.zIndex = 99999999999999;
		this.debuglogs.style.overflow = 'scroll';
		this.debuglogs.style.WebkitOverflowScrolling = 'touch';

		document.body.appendChild(this.debuglogs);
	},

	logs: function(obj) {
		if(this.debug) {
			if(typeof obj === 'string') {
				this.debuglogs.innerHTML += "\n<br />" + obj;
			}else if(typeof obj == 'object') {
				if(typeof obj.action !== "undefined" && typeof obj.value !== "undefined") {
					if(obj.action !== 'witDidGetAudio') {
						this.debuglogs.innerHTML += "\n<br /><strong style=\"text-transform: uppercase\"> - " + obj.action + "</strong";
						if(typeof obj.value === "object") {
							this.debuglogs.innerHTML += "\n<br />" + JSON.stringify(obj.value);
						}else if(typeof obj.value === "string") {
							this.debuglogs.innerHTML += "\n<br />" + obj.value;
						}
					}
				}
			}
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
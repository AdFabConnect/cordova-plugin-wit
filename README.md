#cordova-plugin-wit

This plugin is a wrapper of [wit.ai](https://wit.ai/) ios framework, to use in a cordova application

#Installation

```shell
cordova plugin add https://github.com/AdFabConnect/cordova-plugin-wit.git
```

#Supported Platforms

- iOS

#Methods

- Wit.init
- Wit.toggleCaptureVoiceIntent
- Wit.version

Init method example :

```javascript
/**
 * Init method
 * @param (String) token wit
 */
 Wit.init(' YOUR WIT TOKEN ',
 	/**
 	 * @param (Object) e {value: '', action: ''}
 	 * action : 'witDidGetAudio', 'intent', 'witActivityDetectorStarted', 'witDidStartRecording', 'witDidStopRecording'
 	 */
	function(e) {
		logs.value = i + " / " + e.action + " : " + e.value + "\n" + logs.value;
	}
);
```
 
find your token [here](https://wit.ai/home)

Possible callback value

- action: witDidGetAudio, value: Int
- action: witActivityDetectorStarted, value: NULL
- action: witDidStartRecording, value: NULL
- action: witDidStopRecording, value: NULL
- action: intent, value: Object

Intent obect value

```json
[
  {
    "_text" : " TRUE SPEACH VALUE ",
    "entities" : {

    },
    "confidence" : 0.285,
    "intent" : "BEST_MATCH_INTENT"
  }
]
```

toggleCaptureVoiceIntent method example :

```javascript
Wit.toggleCaptureVoiceIntent()
```

#User location

Add configuration to your Info.plist file

Open Xcode project > **Resources** folder > click **[ PROJECT NAME ]-Info.plist**

Add the config below

> IOS 8 and later:
> NSLocationWhenInUseUsageDescription = To better resolve relative location like "Drive to University Avenue"
> 
> IOS 7:
> NSLocationUsageDescription = To better resolve relative location like "Drive to University Avenue"

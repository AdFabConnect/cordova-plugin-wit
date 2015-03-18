//
//  Wit.h
//  Wit cordova plugin
//
//  Created by nicolas on 17/03/2015.
//  Copyright (c) 2015 adfab. All rights reserved.
//
//

#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>
#import <Wit/Wit.h>

@interface CDVWit : CDVPlugin<WitDelegate> {
    // PHONEGAP
    NSString *WitToken;
    NSString *callbackId;
    CDVPluginResult* pluginResult;
    NSThread *thread;
}

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) toggleCaptureVoiceIntent:(CDVInvokedUrlCommand*)command;

@end
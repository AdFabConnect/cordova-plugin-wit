//
//  Wit.m
//  Wit cordova plugin
//
//  Created by nicolas on 17/03/2015.
//  Copyright (c) 2015 adfab. All rights reserved.
//
//

#import <Cordova/CDV.h>
#import "CDVWit.h"

@implementation CDVWit

- (void)init:(CDVInvokedUrlCommand*)command {
    NSLog(@"init");
    pluginResult = nil;
    callbackId = command.callbackId;
    
    if([command.arguments count] > 0) {
        WitToken = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
        NSLog(@"token %@", WitToken);
    }else {
        WitToken = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token paramter missing"];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSLog(@"WitToken : %@", WitToken);
    [Wit sharedInstance].accessToken = WitToken; // replace xxx by your Wit.AI access token
    //enabling detectSpeechStop will automatically stop listening the microphone when the user stop talking
    [Wit sharedInstance].detectSpeechStop = WITVadConfigDetectSpeechStop;
    
    [Wit sharedInstance].delegate = self;
    
//    thread = [NSThread currentThread];
//    [self.commandDelegate runInBackground:^{
//        [self start];
//    }];
}

- (void) startRecord:(CDVInvokedUrlCommand*)command {
    [[Wit sharedInstance] toggleCaptureVoiceIntent];
    NSLog(@"startRecord");
}

- (void) stopRecord:(CDVInvokedUrlCommand*)command {
    NSLog(@"stopRecord");
}

-(void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)e {
    if (e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[e localizedDescription]];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
    }else {
        NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
        NSString *intent = [firstOutcome objectForKey:@"intent"];
        NSLog(@"intent : %@", intent);
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:intent];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

- (void)witActivityDetectorStarted {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"witActivityDetectorStarted"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)witDidStartRecording {
    NSLog(@"witDidStartRecording");
}


- (void)witDidStopRecording {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"witDidStopRecording"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}


- (void)witDidGetAudio:(NSData *)chunk {
    NSLog(@"witDidGetAudio");
//    NSLog(@"%@", chunk );
}

//
//-(void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e {
//    if (e) {
//        NSLog(@"[Wit] error: %@", [e localizedDescription]);
//        return;
//    }
//    
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:intent];
//    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
//}

@end
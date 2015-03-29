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
    pluginResult = nil;
    callbackId = command.callbackId;
    
    if([command.arguments count] > 0) {
        WitToken = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
    }else {
        WitToken = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token paramter missing"];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    thread = [NSThread currentThread];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Override point for customization after application launch.
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        [Wit sharedInstance].accessToken = WitToken; // replace xxx by your Wit.AI access token
        //enabling detectSpeechStop will automatically stop listening the microphone when the user stop talking
        [Wit sharedInstance].detectSpeechStop = WITVadConfigDetectSpeechStop;
        
        [Wit sharedInstance].delegate = self;
    });
}

- (void) toggleCaptureVoiceIntent:(CDVInvokedUrlCommand*)command {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Wit sharedInstance] toggleCaptureVoiceIntent];
        });
    });
}

-(void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)e {
    if (e) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setValue:@"intent" forKey:@"action"];
        [result setValue:@"[]" forKey:@"value"];
        [result setValue:[e localizedDescription] forKey:@"error"];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }else {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        NSData *json;
        if ([NSJSONSerialization isValidJSONObject:outcomes]) {
            // Serialize the dictionary
            json = [NSJSONSerialization dataWithJSONObject:outcomes options:NSJSONWritingPrettyPrinted error:nil];
            
            // If no errors, let's view the JSON
            if (json != nil) {
                NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                [result setValue:jsonString forKey:@"value"];
            }
        }else {
            NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
            NSString *intent = [firstOutcome objectForKey:@"intent"];
            [result setValue:intent forKey:@"value"];
        }
        [result setValue:@"messageId" forKey:@"messageId"];
        [result setValue:@"intent" forKey:@"action"];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

- (void)witActivityDetectorStarted {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:@"witActivityDetectorStarted" forKey:@"action"];
    [result setValue:@"" forKey:@"value"];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)witDidStartRecording {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:@"witDidStartRecording" forKey:@"action"];
    [result setValue:@"" forKey:@"value"];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}


- (void)witDidStopRecording {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:@"witDidStopRecording" forKey:@"action"];
    [result setValue:@"" forKey:@"value"];
    
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"witDidStopRecording"];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}


- (void)witDidGetAudio:(NSData *)chunk {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:@"witDidGetAudio" forKey:@"action"];
    [result setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[chunk length]] forKey:@"value"];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}


-(void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e {
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        return;
    }
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:@"intent" forKey:@"action"];
    [result setValue:intent forKey:@"value"];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end
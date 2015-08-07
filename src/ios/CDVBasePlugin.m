//  CDVBasePlugin.m
//
//  Copyright 2015 Heyzap, Inc. All Rights Reserved
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "CDVBasePlugin.h"

@interface CDVBasePlugin()

@property (nonatomic, strong) NSString *listenerCallbackId;

- (void)dispatchCallback:(NSString *)event;
- (void)dispatchCallback:(NSString *)event withData:(NSArray *)data;

@end

@implementation CDVBasePlugin

- (UIViewController *)topMostViewController {
    UIViewController *topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
    }
    
    return topController;
}

- (void)addEventListener:(CDVInvokedUrlCommand *)command {
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:@[@"OK"]];
    
    if (!self.listenerCallbackId) {
        self.listenerCallbackId = command.callbackId;
        [result setKeepCallbackAsBool:YES];
        [self addDelegate];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)addDelegate {
    // Subclass must override this
}

#pragma mark - Network callback
NSString *const NETWORK_CALLBACK = @"networkCallbacks";

- (void) networkCallback:(NSString *)network callback:(NSString *)callback {
    [self dispatchCallback:NETWORK_CALLBACK withData:@[network, callback]];
}

#pragma mark - HZAdsDelegate methods

NSString *const SHOW_CALLBACK = @"show";
NSString *const HIDE_CALLBACK = @"hide";
NSString *const SHOW_FAILED_CALLBACK = @"show_failed";
NSString *const AVAILABLE_CALLBACK = @"available";
NSString *const FETCH_FAILED_CALLBACK = @"fetch_failed";
NSString *const AUDIO_STARTED_CALLBACK = @"audio_started";
NSString *const AUDIO_FINISHED_CALLBACK = @"audio_finished";
NSString *const CLICKED_CALLBACK = @"clicked";

- (void) didShowAdWithTag:(NSString *)tag {
    [self dispatchCallback:SHOW_CALLBACK withData:@[tag]];
}

- (void) didFailToShowAdWithTag:(NSString *)tag andError:(NSError *)error {
    [self dispatchCallback:SHOW_FAILED_CALLBACK withData:@[tag, [error localizedDescription]]];
}

- (void) didClickAdWithTag:(NSString *)tag {
    [self dispatchCallback:CLICKED_CALLBACK withData:@[tag]];
}

- (void) didHideAdWithTag:(NSString *)tag {
    [self dispatchCallback:HIDE_CALLBACK withData:@[tag]];
}

- (void) didReceiveAdWithTag:(NSString *)tag {
    [self dispatchCallback:AVAILABLE_CALLBACK withData:@[tag]];
}

- (void) didFailToReceiveAdWithTag: (NSString *)tag {
    [self dispatchCallback:FETCH_FAILED_CALLBACK withData:@[tag]];
}

- (void) willStartAudio {
    [self dispatchCallback:AUDIO_STARTED_CALLBACK];
}

- (void) didFinishAudio {
    [self dispatchCallback:AUDIO_FINISHED_CALLBACK];
}

#pragma mark - HZIncentivizedAdDelegate methods

NSString *const COMPLETE_CALLBACK = @"complete";
NSString *const INCOMPLETE_CALLBACK = @"incomplete";

- (void) didCompleteAdWithTag: (NSString *)tag {
    [self dispatchCallback:COMPLETE_CALLBACK withData:@[tag]];
}

- (void) didFailToCompleteAdWithTag: (NSString *)tag {
    [self dispatchCallback:INCOMPLETE_CALLBACK withData:@[tag]];
}

#pragma mark - HZBannerAdDelegate methods

NSString *const ERROR_CALLBACK = @"error";
NSString *const LOADED_CALLBACK = @"loaded";

- (void)bannerDidReceiveAd:(HZBannerAd *)banner {
    [self dispatchCallback:LOADED_CALLBACK];
}

- (void)bannerDidFailToReceiveAd:(HZBannerAd *)banner error:(NSError *)error {
    [self dispatchCallback:ERROR_CALLBACK];
}

- (void)bannerWasClicked:(HZBannerAd *)banner {
    [self dispatchCallback:CLICKED_CALLBACK];
}

# pragma mark - dispatch callback methods

- (void)dispatchCallback:(NSString *)event {
    [self dispatchCallback:event withData:@[]];
}

- (void)dispatchCallback:(NSString *)event withData:(NSArray *)data {
    NSMutableArray *mData = [NSMutableArray array];
    [mData insertObject:event atIndex:0];
    [mData addObjectsFromArray:data];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:mData];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:self.listenerCallbackId];
}

@end

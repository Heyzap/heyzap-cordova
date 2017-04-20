//  CDVHeyzapAds.h
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

#import "CDVHeyzapAds.h"
#import <HeyzapAds/HeyzapAds.h>

@interface CDVHeyzapAds()

@property (nonatomic, strong) NSDictionary *startOptions;

- (NSUInteger)startOptionsFromDictionary:(NSDictionary *)jsOptions;

@end

@implementation CDVHeyzapAds

# pragma mark - Cordova exec methods

NSString *const HZ_FRAMEWORK = @"cordova";

- (void)start:(CDVInvokedUrlCommand *)command {
    __weak CDVHeyzapAds *weakSelf = self;
    
    [self.commandDelegate runInBackground:^{
        
        @try {
            NSString *publisherID = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSDictionary *jsOptions = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];
            
            NSUInteger options = [weakSelf startOptionsFromDictionary:jsOptions];
            
            if (publisherID) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HeyzapAds startWithPublisherID:publisherID andOptions:options andFramework: HZ_FRAMEWORK];
                    
                    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
                });
                
            } else {
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"publisher ID is missing."];
                [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
            }
        }
        @catch (NSException *e) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        }
    }];
}

- (void)mediationTestSuite:(CDVInvokedUrlCommand *)command {
    
    @try {
        __weak CDVHeyzapAds *weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HeyzapAds presentMediationDebugViewController];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        });
    }
    @catch (NSException *e) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

- (void)remoteData:(CDVInvokedUrlCommand *)command {
    NSDictionary *data = [HeyzapAds remoteData];
    
    CDVPluginResult *result;
    
    if (data) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
        
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to fetch remote data."];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)onIAPComplete:(CDVInvokedUrlCommand *)command {
    __weak CDVHeyzapAds *weakSelf = self;
    
    @try {
        NSString *productId = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
        NSString *productName = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
        NSDecimalNumber *price = [command argumentAtIndex:0 withDefault:0 andClass:[NSDecimalNumber class]];
        
        [HeyzapAds onIAPPurchaseComplete:productId productName:productName price:price];
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
    
    }
    @catch (NSException *e) {
       CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
       [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
    }
}

#pragma mark - Overriden Methods
- (void)addDelegate {
    [HeyzapAds networkCallbackWithBlock:^(NSString *network, NSString *callback) {
        [self networkCallback:network callback:callback];
    }];
}

# pragma mark - Other
- (NSUInteger)startOptionsFromDictionary:(NSDictionary *)jsOptions {
    NSUInteger options = HZAdOptionsNone;
    
    if (jsOptions) {
        for (NSString *key in jsOptions) {
            if ([self.startOptions objectForKey:key]) {
                options = options | (NSUInteger)[self.startOptions objectForKey:key];
            }
        }
    }
    
    return options;
}

- (NSDictionary *)startOptions {
    if (!_startOptions) {
        _startOptions = @{
                          @"none": @(HZAdOptionsNone),
                          @"disableAutomaticPrefetch": @(HZAdOptionsDisableAutoPrefetching),
                          @"installTrackingOnly": @(HZAdOptionsInstallTrackingOnly),
                          @"amazon": @(HZAdOptionsAmazon),
                          @"disableMediation": @(HZAdOptionsDisableMedation),
                          @"disableAutomaticIAPRecording": @(HZAdOptionsDisableAutomaticIAPRecording)
                          };
    }
    
    return _startOptions;
}

@end
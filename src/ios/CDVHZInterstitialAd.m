//  CDVHZInterstitialAd.m
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

#import "CDVHZInterstitialAd.h"

@implementation CDVHZInterstitialAd

# pragma mark - Cordova exec methods

- (void)fetch:(CDVInvokedUrlCommand *)command {
    __weak CDVHZInterstitialAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CDVPluginResult *result;
        
        @try {
            NSString *tag = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
            
            if (tag) {
                [HZInterstitialAd fetchForTag:tag];
                
            } else {
                [HZInterstitialAd fetch];
            }
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        @catch (NSException *e) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
        }
        
        [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
    });
}

- (void)show:(CDVInvokedUrlCommand *)command {
    __weak CDVHZInterstitialAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CDVPluginResult *result;
        
        @try {
            NSString *tag = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
            
            HZShowOptions *options = [[HZShowOptions alloc] init];
            options.tag = tag;
            options.viewController = [self topMostViewController];
            
            [HZInterstitialAd showWithOptions:options];
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            
        }
        @catch (NSException *e) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
        }
        
        [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
    });
}

#pragma mark - Overriden Methods
- (void)addDelegate {
    [HZInterstitialAd setDelegate:self];
}

@end
//
//  CDVHZBannerAd.m
//  Hello
//
//  Created by Karim Piyarali on 7/27/15.
//
//

#import "CDVHZBannerAd.h"

@interface CDVHZBannerAd()

@property (nonatomic, strong) HZBannerAd *currentBannerAd;
@property (nonatomic, strong) NSString *currentBannerPosition;
@property (nonatomic, strong) NSDictionary *bannerSizes;

- (HZBannerAdOptions *)bannerOptionsFromDictionary:(NSDictionary *)jsOptions;

@end

@implementation CDVHZBannerAd

# pragma mark - Cordova exec methods

NSString *const POSITION_TOP = @"top";
NSString *const POSITION_BOTTOM = @"bottom";

- (void)show:(CDVInvokedUrlCommand *)command {
    
    __weak CDVHZBannerAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {

            NSString *jsPosition = [command argumentAtIndex:0 withDefault:POSITION_BOTTOM andClass:[NSString class]];
            NSDictionary *jsOptions = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];
            NSString *tag = [command argumentAtIndex:2 withDefault:@"" andClass:[NSString class]];
            
            if ([weakSelf currentBannerAd] && [weakSelf currentBannerPosition]) {
                if ([[weakSelf currentBannerPosition] isEqualToString:jsPosition]) {
                    [[weakSelf currentBannerAd] setHidden:NO];
                    
                    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
                    return;
                    
                } else {
                    [[weakSelf currentBannerAd] removeFromSuperview];
                    [weakSelf setCurrentBannerAd: nil];
                    [weakSelf setCurrentBannerPosition:nil];
                }
            }
            
            NSUInteger position = HZBannerPositionBottom;
            
            if ([jsPosition isEqualToString:POSITION_TOP]) {
                position = HZBannerPositionTop;
            }
            
            HZBannerAdOptions *options = [weakSelf bannerOptionsFromDictionary:jsOptions];
            options.tag = tag;
            
            [HZBannerAd placeBannerInView:nil position:position options:options success:^(HZBannerAd *banner) {
                [weakSelf setCurrentBannerAd:banner];
                [weakSelf setCurrentBannerPosition:jsPosition];
                [weakSelf addDelegate];
                [weakSelf bannerDidReceiveAd:banner];
                
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
                
            } failure:^(NSError *error) {
                NSLog(@"Could not load banner. Error = %@", error);
                
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
                [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
                
            }];
            
        }
        @catch (NSException *e) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        }
        
    });
}

- (void)hide:(CDVInvokedUrlCommand *)command {
    
    __weak CDVHZBannerAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            if (![weakSelf currentBannerAd] || [[weakSelf currentBannerAd] isHidden]) {
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"There is no banner ad currently showing."];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

            } else {
                [[weakSelf currentBannerAd] setHidden:YES];
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

            }
        }
        @catch (NSException *e) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        }
    });
}

- (void)destroy:(CDVInvokedUrlCommand *)command {
    
    __weak CDVHZBannerAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            if (![weakSelf currentBannerAd]) {
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"There is no banner ad currently showing."];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                
            } else {
                [[weakSelf currentBannerAd] removeFromSuperview];
                [weakSelf setCurrentBannerAd:nil];
                [weakSelf setCurrentBannerPosition:nil];
                
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                
            }
        }
        @catch (NSException *e) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        }
    });
}

- (void)dimensions:(CDVInvokedUrlCommand *)command {
    __weak CDVHZBannerAd *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            NSMutableDictionary *dimensions = [NSMutableDictionary dictionaryWithDictionary: @{
                                         @"x": @0,
                                         @"y": @0,
                                         @"width": @0,
                                         @"height": @0
                                         }];
            
            if ([weakSelf currentBannerAd]) {
                
                // for converting from points to pixels
                CGFloat scale = [[UIScreen mainScreen] scale];
                CGRect frame = [[weakSelf currentBannerAd] frame];
                
                dimensions[@"x"] = @(frame.origin.x * scale);
                dimensions[@"y"] = @(frame.origin.y * scale);
                dimensions[@"width"] = @(frame.size.width * scale);
                dimensions[@"height"] = @(frame.size.height * scale);
            }
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dimensions];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
        @catch (NSException *e) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.description];
            [[weakSelf commandDelegate] sendPluginResult:result callbackId:command.callbackId];
        }
    });
}

#pragma mark - Overriden Methods

- (void)addDelegate {
    [self.currentBannerAd setDelegate:self];
}

#pragma mark - Other

NSString *const FACEBOOK_SIZE_PROPERTY = @"facebookBannerSize";
NSString *const ADMOB_SIZE_PROPERTY = @"admobBannerSize";
NSString *const ADMOB_SIZE_SMART = @"SMART";

- (HZBannerAdOptions *)bannerOptionsFromDictionary:(NSDictionary *)jsOptions {
    HZBannerAdOptions *options = [[HZBannerAdOptions alloc] init];
    
    if (jsOptions) {
        
        NSString *jsFacebookBannerSize = [jsOptions objectForKey:FACEBOOK_SIZE_PROPERTY];
        NSUInteger facebookBannerSize = [[self.bannerSizes objectForKey:jsFacebookBannerSize] unsignedIntegerValue];
        if (facebookBannerSize) {
            options.facebookBannerSize = facebookBannerSize;
        }
        
        NSString *jsAdMobBannerSize = [jsOptions objectForKey:ADMOB_SIZE_PROPERTY];
        NSUInteger admobBannerSize;
        
        if ([jsAdMobBannerSize isEqualToString:ADMOB_SIZE_SMART]) {
            
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
                admobBannerSize = HZAdMobBannerSizeFlexibleWidthPortrait;
            } else {
                admobBannerSize = HZAdMobBannerSizeFlexibleWidthLandscape;
            }
        } else {
            admobBannerSize = [[self.bannerSizes objectForKey:jsFacebookBannerSize] unsignedIntegerValue];
        }

        if (admobBannerSize) {
            options.admobBannerSize = admobBannerSize;
        }
    }
    
    return options;
}

- (NSDictionary *)bannerSizes {
    if (!_bannerSizes) {
        
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _bannerSizes = @{
                         @"320_50": @(HZFacebookBannerSize320x50),
                         @"HEIGHT_50": @(HZFacebookBannerSizeFlexibleWidthHeight50),
                         @"HEIGHT_90": @(HZFacebookBannerSizeFlexibleWidthHeight90),
                         
                         @"STANDARD": @(HZAdMobBannerSizeBanner),
                         @"LARGE": @(HZAdMobBannerSizeLargeBanner),
                         @"FULL_SIZE": @(HZAdMobBannerSizeFullBanner),
                         @"LEADERBOARD": @(HZAdMobBannerSizeLeaderboard),
                         @"SMART": @(HZAdMobBannerSizeFlexibleWidthPortrait)
                         };
    }
    
    return _bannerSizes;
}

@end

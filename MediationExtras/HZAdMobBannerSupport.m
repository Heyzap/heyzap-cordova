//
//  AdMobBannerSupport.m
//  Heyzap
//
//  Created by Maximilian Tagher on 3/23/15.
//  Copyright (c) 2015 Heyzap. All rights reserved.
//

#import "HZAdMobBannerSupport.h"

@implementation HZAdMobBannerSupport

#pragma mark Standard Sizes

/// iPhone and iPod Touch ad size. Typically 320x50.
extern GADAdSize const kGADAdSizeBanner;

/// Taller version of kGADAdSizeBanner. Typically 320x100.
extern GADAdSize const kGADAdSizeLargeBanner;

/// Medium Rectangle size for the iPad (especially in a UISplitView's left pane). Typically 300x250.
extern GADAdSize const kGADAdSizeMediumRectangle;

/// Full Banner size for the iPad (especially in a UIPopoverController or in
/// UIModalPresentationFormSheet). Typically 468x60.
extern GADAdSize const kGADAdSizeFullBanner;

/// Leaderboard size for the iPad. Typically 728x90.
extern GADAdSize const kGADAdSizeLeaderboard;

+ (GADAdSize)adSizeNamed:(NSString *)name {
    if ([name isEqualToString:@"kGADAdSizeSmartBannerPortrait"]) {
        return kGADAdSizeSmartBannerPortrait;
    } else if ([name isEqualToString:@"kGADAdSizeSmartBannerLandscape"]) {
        return kGADAdSizeSmartBannerLandscape;
    } else if ([name isEqualToString:@"kGADAdSizeBanner"]) {
        return kGADAdSizeBanner;
    } else if ([name isEqualToString:@"kGADAdSizeLargeBanner"]) {
        return kGADAdSizeLargeBanner;
    } else if ([name isEqualToString:@"kGADAdSizeLeaderboard"]) {
        return kGADAdSizeLeaderboard;
    } else if ([name isEqualToString:@"kGADAdSizeFullBanner"]) {
        return kGADAdSizeFullBanner;
    } else {
        NSLog(@"[Heyzap] Unrecognized GADAdSize requested; requested size = %@. This is a bug in the Heyzap SDK; please report it to support@heyzap.com. Defaulting to kGADAdSizeSmartBannerPortrait",name);
        return kGADAdSizeSmartBannerPortrait;
    }
}

@end

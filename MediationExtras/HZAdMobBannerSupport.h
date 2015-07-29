//
//  AdMobBannerSupport.h
//  Heyzap
//
//  Created by Maximilian Tagher on 3/23/15.
//  Copyright (c) 2015 Heyzap. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GoogleMobileAds;

/**
 *  This class provides
 */
@interface HZAdMobBannerSupport : NSObject

+ (GADAdSize)adSizeNamed:(NSString *)name;

@end

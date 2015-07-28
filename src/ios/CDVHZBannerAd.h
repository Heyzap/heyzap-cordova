//
//  CDVHZBannerAd.h
//  Hello
//
//  Created by Karim Piyarali on 7/27/15.
//
//

#import "CDVBasePlugin.h"

@interface CDVHZBannerAd : CDVBasePlugin

- (void)show:(CDVInvokedUrlCommand *)command;
- (void)hide:(CDVInvokedUrlCommand *)command;
- (void)dimensions:(CDVInvokedUrlCommand *)command;

@end

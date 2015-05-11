//
//  AdformSDK.h
//  AdformAdvertising
//
//  Copyright (c) 2014 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Generic Adform Advertising SDK class, used to provide global functions.
 */
@interface AdformSDK : NSObject

/**
 Returns SDK version as a string value.
 */
+ (NSString *)sdkVersion;

/**
 Use this method to set publisher id.
 
 You can also add custom key-value pair data to target ads to your users even more accurately, e.g. @{@"gender": @"male"}.
 This parameter works globally to all ad placements.
 This parameter can be modified only before the first successful ad request (you can still set it later if you haven't done it before requesting ads).
 
 @param publisherId An NSInteger with publisher id.
 @param customData An NSDictionary with custom key-value pair data.
 */
+ (void)setPublisherId:(NSInteger)publisherId andCustomData:(NSDictionary *)customData;

/**
 Use this property to allow or deny the sdk to use current user location.
 
 By default use of location is disabled.
 Enabling the use of current user location will allow sdk to server ads more accurately.
 
 @warning You need to define NSLocationWhenInUseUsageDescription key in your applications info.plist file, if you don't have one.
 Set it's text to "Your location is used to show relevant ads nearby." or its translation.
 
 @param allowed Boolean value indicating if use of current user location should be allowed or denied.
 */
+ (void)allowUseOfLocation:(BOOL )allowed;

/**
 You can use this to check if the use of current user location is allowed.
 */
+ (BOOL)isUseOfLocationAllowed;

@end

//
//  AFNativeResponse.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFNativeResponseAsset;
@class AFAdLink;
@class AFTrackingEvent;

/**
 Represents the native ad response in an OpenRTB bid.
 */
@interface AFNativeResponse : NSObject <JSONConvertable>

/** Corresponds to JSON "ver" */
@property (nonatomic, copy, nullable) NSString *ver;

/** Corresponds to JSON "assets" */
@property (nonatomic, copy, nullable) NSArray<AFNativeResponseAsset *> *assets;

/** Corresponds to JSON "asseturl" */
@property (nonatomic, copy, nullable) NSString *assetUrl;

/** Corresponds to JSON "dcourl" */
@property (nonatomic, copy, nullable) NSString *dcoUrl;

/** Corresponds to JSON "link" */
@property (nonatomic, strong, nullable) AFAdLink *link;

/** Corresponds to JSON "imptrackers" */
@property (nonatomic, copy, nullable) NSArray<NSString *> *imptrackers;

/** Corresponds to JSON "jstracker" */
@property (nonatomic, copy, nullable) NSString *jsTracker;

/** Corresponds to JSON "eventtrackers" */
@property (nonatomic, copy, nullable) NSArray<AFTrackingEvent *> *eventTrackers;

/** Corresponds to JSON "privacy" */
@property (nonatomic, copy, nullable) NSString *privacy;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

//
//  AFBid.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFNativeResponse;
@class AFBidExt;

/**
 Represents a single bid in an OpenRTB seatbid.
 */
@interface AFBid : NSObject <JSONConvertable>

/** Corresponds to JSON "id" */
@property (nonatomic, copy, nullable) NSString *bidId;

/** Corresponds to JSON "impid" */
@property (nonatomic, copy, nullable) NSString *impId;

/** Corresponds to JSON "price" */
@property (nonatomic, copy, nullable) NSDecimalNumber *price;

/** Corresponds to JSON "nurl" */
@property (nonatomic, copy, nullable) NSString *nurl;

/** Corresponds to JSON "adm" */
@property (nonatomic, copy, nullable) NSString *adm;

/** Corresponds to JSON "native" */
@property (nonatomic, strong, nullable) AFNativeResponse *nativeResponse;

/** Corresponds to JSON "adomain" */
@property (nonatomic, copy, nullable) NSArray<NSString *> *adomain;

/** Corresponds to JSON "crid" */
@property (nonatomic, copy, nullable) NSString *crid;

/** Corresponds to JSON "cat" */
@property (nonatomic, copy, nullable) NSArray<NSString *> *cat;

/** Corresponds to JSON "dealid" */
@property (nonatomic, copy, nullable) NSString *dealId;

/** Corresponds to JSON "w" */
@property (nonatomic, copy, nullable) NSNumber *w;

/** Corresponds to JSON "h" */
@property (nonatomic, copy, nullable) NSNumber *h;

/** Corresponds to JSON "dur" */
@property (nonatomic, copy, nullable) NSNumber *dur;

/** Corresponds to JSON "ext" */
@property (nonatomic, strong, nullable) AFBidExt *ext;

/**
 A holder for cookies associated with this bid; not serialized.
 */
@property (nonatomic, strong, nullable) NSSet *responseCookies;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

//
//  AFSeatBid.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFBid;

/**
 Represents a seatbid in an OpenRTB response.
 */
@interface AFSeatBid : NSObject <JSONConvertable>

/** Corresponds to JSON "bid" */
@property (nonatomic, copy, nullable) NSArray<AFBid *> *bid;

/** Corresponds to JSON "seat" */
@property (nonatomic, copy, nullable) NSString *seat;

/** Corresponds to JSON "group" */
@property (nonatomic, copy, nullable) NSString *group;

/**
 A holder for cookies associated with this seatbid; not serialized.
 */
@property (nonatomic, strong, nullable) NSSet *responseCookies;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

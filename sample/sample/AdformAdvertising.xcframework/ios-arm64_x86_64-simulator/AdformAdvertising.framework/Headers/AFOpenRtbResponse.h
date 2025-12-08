//
//  AFOpenRtbResponse.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSeatBid;

/**
 Represents the OpenRTB Bid Response object as defined in the OpenRTB 2.5 specification (Section 4.2).
 */
@interface AFOpenRtbResponse : NSObject <JSONConvertable>

/** Corresponds to JSON "id". ID of the bid request to which this response applies. */
@property (nonatomic, copy, nullable) NSString *rtbId;
/** Corresponds to JSON "seatbid". Array of SeatBid objects each containing bids for specific seats. */
@property (nonatomic, copy, nullable) NSArray<AFSeatBid *> *seatBid;
/** Corresponds to JSON "bidid". Bidder-generated response ID to assist with logging/tracking. */
@property (nonatomic, copy, nullable) NSString *bidId;
/** Corresponds to JSON "cur". Currency of the bid response using ISO-4217 alpha codes. */
@property (nonatomic, copy, nullable) NSString *currency;
/** Corresponds to JSON "error". Error message or reason for no-bid. */
@property (nonatomic, copy, nullable) NSString *error;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

/**
 Serializes this OpenRTB response into JSON data.

 @param error Pointer to an NSError object to receive any serialization error.
 @return NSData containing the JSON representation, or nil if serialization fails.
 */
- (nullable NSData *)toJSONDataWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

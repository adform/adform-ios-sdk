//
//  AFBidExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFResponsePrebid;
@class AFResponseDsaExt;

/**
 Extension object for an OpenRTB bid response.
 */
@interface AFBidExt : NSObject <JSONConvertable>

/** Corresponds to JSON "prebid" */
@property (nonatomic, strong, nullable) AFResponsePrebid *prebid;

/** Corresponds to JSON "dsa" */
@property (nonatomic, strong, nullable) AFResponseDsaExt *dsa;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

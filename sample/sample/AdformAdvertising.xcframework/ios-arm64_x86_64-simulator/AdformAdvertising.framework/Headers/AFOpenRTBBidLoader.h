//
//  AFOpenRTBBidLoader.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFOpenRtbRequest;
@class AFOpenRtbResponse;

NS_ASSUME_NONNULL_BEGIN

/**
 A loader for OpenRTB native ad requests.
 */
@interface AFOpenRTBBidLoader : NSObject

/** Returns the shared OpenRTB bid loader instance. */
+ (instancetype)defaultLoader;

/**
 Requests ads via OpenRTB.
 
 @param rtbRequest        The OpenRTB request object.
 @param completion        Completion block called with an AFOpenRtbResponse or error.
 */
- (void)requestAd:(AFOpenRtbRequest *)rtbRequest
  withCompletionHandler:(void(^)(AFOpenRtbResponse * _Nullable response, NSError * _Nullable error))completion;

/**
 Requests ads via OpenRTB.
 
 @param rtbRequest        The OpenRTB request object.
 @param completion        Completion block called with an AFOpenRtbResponse or error.
 */
+ (void)requestAd:(AFOpenRtbRequest *)rtbRequest
  withCompletionHandler:(void(^)(AFOpenRtbResponse * _Nullable response, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

//
//  AFAdRequest.h
//  AdformHeaderBidding
//
//  Created by Vladas Drejeris on 17/02/16.
//  Copyright © 2016 adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHBConstants.h"

@interface AFBidRequest : NSObject

/**
 Master tag id provided be Adform.
 */
@property (nonatomic, assign) NSInteger masterTagId;
/**
 Placement type for the bid.
 */
@property (nonatomic, assign) AFAdPlacementType placementType;
/**
 An array of NSValue encoded CGSize structures defining ad sizes supported by the placement.
 
 For convenience you can use 'AFAdDimension' or 'AFAdDimensionFromCGSize' functions to create NSValue objects.
 
 Example:
    \code
        adView.supportedDimmensions = @[AFAdDimension(320, 50), AFAdDimension(320, 150)];
    \endcode
 */
@property (nonatomic, strong) NSArray<NSValue *> *supportedAdSizes;
/**
 A timeout for the bid request.
 */
@property (nonatomic, assign) NSTimeInterval bidTimeOut;
/**
 Defines which adx server should be used.
 
 @see AFAdxDomain
 */
@property (nonatomic, assign) AFAdxDomain adxDomain;


/**
 Unix timestamp identifying when bid was requested.
 */
@property (nonatomic, assign, readonly) NSTimeInterval requestTimestamp;


/**
 Creates a new AFBidRequest instance.
 
 @param mTag A master tag id provided to you by Adform.
 @param placementType The placement type.
 @param adSizes An array of NSValue encoded CGSize structures defining ad sizes supported by the placement.
 
 @return A newly created AFBidRequest instance.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mTag
                      palcementType:(AFAdPlacementType )placementType
                   supportedAdSizes:(NSArray<NSValue *> *)adSizes;

@end

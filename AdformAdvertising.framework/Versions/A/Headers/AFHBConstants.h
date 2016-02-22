//
//  AFHBConstants.h
//  AdformHeaderBidding
//
//  Created by Vladas Drejeris on 17/02/16.
//  Copyright © 2016 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Defines placement types supported by adx.
 */
typedef NS_ENUM (NSInteger, AFAdPlacementType) {
    AFAdPlacementTypeInline,
    AFAdPlacementTypeInterstitial
};

extern NSValue *AFAdDimension(CGFloat width, CGFloat height);
extern NSValue *AFAdDimensionFromCGSize(CGSize size);
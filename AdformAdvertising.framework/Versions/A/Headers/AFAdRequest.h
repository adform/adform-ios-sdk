//
//  AFAdRequest.h
//  AdformHeaderBidding
//
//  Created by Vladas Drejeris on 17/02/16.
//  Copyright © 2016 adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHBConstants.h"

@interface AFAdRequest : NSObject

@property (nonatomic, assign) NSInteger masterTagId;
@property (nonatomic, assign) AFAdPlacementType placementType;
@property (nonatomic, strong) NSArray *supportedAdSizes;

// TODO: Write unit tests
- (instancetype)initWithMasterTagId:(NSInteger )mTag
                      palcementType:(AFAdPlacementType )placementType
                   supportedAdSizes:(NSArray *)adSizes;

@end

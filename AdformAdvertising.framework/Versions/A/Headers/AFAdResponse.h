//
//  AFAdResponse.h
//  AdformHeaderBidding
//
//  Created by Vladas Drejeris on 17/02/16.
//  Copyright © 2016 adform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFAdRequest;

@interface AFAdResponse : NSObject

/**
 Refresh interval of the ad creative.
 */
@property (nonatomic, assign) NSTimeInterval refreshInterval;
/**
 Banner source.
 */
@property (nonatomic, strong) NSString *source;
/**
 Identifies banner size.
 */
@property (nonatomic, assign) CGSize adSize;

/**
 Combined client side impression URL.
 */
@property (nonatomic, strong) NSURL *impressionURL;
/**
 Base URL for client side impressions.
 */
@property (nonatomic, strong) NSURL *trackingUrlBase;

/**
 Server API version used to get ad serving.
 */
@property (nonatomic, strong) NSString *version;

/**
 Bid price used for header bidding.
 */
@property (nonatomic, assign) double bidPrice;


/**
 Original ad request that was used.
 */
@property (nonatomic, strong) AFAdRequest *adRequest;

@end

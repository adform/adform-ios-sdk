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

typedef NS_ENUM(NSInteger, AFHBErrorCode) {
    
    /// A network error occurred while loading ads from server.
    AFHBNetworkConnectionError = 0,
    
    /// The request has timed out.
    AFHBRequestTimeOutError = 1,
    
    /// An ad server error occurred.
    AFHBServerError = 2,
    
    /// The ad server returned invalid response.
    AFHBInvalidServerResponseError = 4,
    
    /// Provided bid request is invalid.
    AFHBInvalidBidRequestError = 5
};

/**
 Defines available adx servers.
 */
typedef NS_ENUM(NSInteger, AFAdxDomain) {
    
    /// Adx server used for European markets.
    AFAdxDomainEUR = 100,
    
    /// Adx server used for USA markets.
    AFAdxDomainUSA = 101,
    
    /// European adx server is the default one.
    AFAdxDomainDefault = AFAdxDomainEUR
};

extern NSValue *AFAdDimensionFromCGSize(CGSize size);
extern NSValue *AFAdDimension(CGFloat width, CGFloat height);
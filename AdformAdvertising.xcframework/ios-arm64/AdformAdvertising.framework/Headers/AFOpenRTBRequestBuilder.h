//
//  AFOpenRTBRequestBuilder.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 20/06/2025.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFOpenRtbRequest;
@class AFImp;
@class AFUser;
@class AFApp;
@class AFDevice;
@class AFSite;
@class AFSource;
@class AFRegs;
@class AFRequestExt;

/**
 Convenience builder for constructing the OpenRTB Bid Request object as defined in the
 OpenRTB 2.5 specification (Section 3.2).
 */
@interface AFOpenRTBRequestBuilder : NSObject

/** Corresponds to JSON "id". Unique ID for the bid request. */
@property (nonatomic, copy) NSString *rtbId;
/** Corresponds to JSON "imp". Array of Imp objects representing the impressions. */
@property (nonatomic, copy, nullable) NSArray<AFImp *> *imps;
/** Corresponds to JSON "test". Indicator of test mode; 0 = live, 1 = test. */
@property (nonatomic, strong, nullable) NSNumber *test;
/** Corresponds to JSON "user". User related information. */
@property (nonatomic, strong, nullable) AFUser *user;
/** Corresponds to JSON "app". Application making the request (if applicable). */
@property (nonatomic, strong, nullable) AFApp *app;
/** Corresponds to JSON "device". Device making the request. */
@property (nonatomic, strong, nullable) AFDevice *device;
/** Corresponds to JSON "site". Website making the request (if applicable). */
@property (nonatomic, strong, nullable) AFSite *site;
/** Corresponds to JSON "source". Source of the bid request for supply chain info. */
@property (nonatomic, strong, nullable) AFSource *source;
/** Corresponds to JSON "regs". Regulatory and privacy information. */
@property (nonatomic, strong, nullable) AFRegs *regs;
/** Corresponds to JSON "ext". Extension object for exchange-specific enhancements. */
@property (nonatomic, strong, nullable) AFRequestExt *ext;
/** Corresponds to JSON "cur". Array of allowed currencies. */
@property (nonatomic, copy, nullable) NSArray<NSString *> *currencies;

/// Designated initializer.
- (instancetype)initWithRtbId:(NSString *)rtbId
                         imps:(nullable NSArray<AFImp *> *)imps;

/// Creates and returns a configured AFOpenRtbRequest object.
- (AFOpenRtbRequest *)createOpenRtbRequest;

@end

NS_ASSUME_NONNULL_END

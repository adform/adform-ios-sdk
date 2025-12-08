//
//  AFOpenRtbRequest.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFApp;
@class AFDevice;
@class AFRegs;
@class AFRequestExt;
@class AFSite;
@class AFSource;
@class AFUser;
@class AFImp;

/**
 Represents the OpenRTB Bid Request object as defined in the OpenRTB 2.5 specification (Section 3.2).
 */
@interface AFOpenRtbRequest : NSObject <JSONConvertable>

/** Corresponds to JSON "id". Unique ID for the bid request.*/
@property (nonatomic, copy) NSString *rtbId;
/** Corresponds to JSON "imp". Array of Imp objects representing the impressions. */
@property (nonatomic, copy, nullable) NSArray<AFImp *> *imps;
/** Corresponds to JSON "test". Indicator of test mode; 0 = live, 1 = test.*/
@property (nonatomic, copy, nullable) NSNumber *test;
/** Corresponds to JSON "device". Device making the request. */
@property (nonatomic, strong, nullable) AFDevice *device;
/** Corresponds to JSON "user". User related information. */
@property (nonatomic, strong, nullable) AFUser *user;
/** Corresponds to JSON "app". Application making the request (if applicable). */
@property (nonatomic, strong, nullable) AFApp *app;
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
/** ADX domain to use. Available values: kAFAdxDomainEUR, kAFAdxDomainUSA, kAFAdxDomainDefault.*/
@property (nonatomic, copy) NSString *adxDomain;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

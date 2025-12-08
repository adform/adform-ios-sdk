//
//  AFDevice.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFGeo;
@class AFStructuredUserAgent;

@interface AFDevice : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *userAgent;
@property (nonatomic, strong, nullable) AFStructuredUserAgent *structuredUserAgent;
@property (nonatomic, copy, nullable) NSString *ip;
@property (nonatomic, copy, nullable) NSString *iPv6;
@property (nonatomic, copy, nullable) NSString *language;
@property (nonatomic, copy, nullable) NSString *ifa;
@property (nonatomic, copy, nullable) NSNumber *limitAdTracking;
@property (nonatomic, strong, nullable) AFGeo *geo;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

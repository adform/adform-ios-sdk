//
//  AFStructuredUserAgent.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFBrandVersion;

@interface AFStructuredUserAgent : NSObject <JSONConvertable>

@property (nonatomic, strong, nullable) NSArray<AFBrandVersion *> *browsers;
@property (nonatomic, strong, nullable) AFBrandVersion *platform;
@property (nonatomic, copy, nullable) NSNumber *mobile;
@property (nonatomic, copy, nullable) NSString *architecture;
@property (nonatomic, copy, nullable) NSString *bitness;
@property (nonatomic, copy, nullable) NSString *model;
@property (nonatomic, copy, nullable) NSNumber *source;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

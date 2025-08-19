//
//  AFBannerFormat.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFBannerFormat;

@interface AFBanner : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *width;
@property (nonatomic, copy, nullable) NSNumber *height;
@property (nonatomic, copy, nullable) NSNumber *position;
@property (nonatomic, strong, nullable) NSArray<AFBannerFormat *> *format;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

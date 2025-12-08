//
//  AFRequestExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFRequestPrebid;

@interface AFRequestExt : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *priceType;
@property (nonatomic, strong, nullable) AFRequestPrebid *prebid;
@property (nonatomic, copy, nullable) NSNumber *multibid;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

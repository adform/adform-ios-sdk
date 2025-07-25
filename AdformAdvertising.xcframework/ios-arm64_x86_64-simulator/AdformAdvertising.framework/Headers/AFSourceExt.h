//
//  AFSourceExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSupplyChain;

@interface AFSourceExt : NSObject <JSONConvertable>

@property (nonatomic, strong, nullable) AFSupplyChain *supplyChain;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

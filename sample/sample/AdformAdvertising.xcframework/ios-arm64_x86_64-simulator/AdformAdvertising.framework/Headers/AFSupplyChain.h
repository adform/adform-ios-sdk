//
//  AFSupplyChain.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

@class AFSupplyChainNode;

NS_ASSUME_NONNULL_BEGIN

@interface AFSupplyChain : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *complete;
@property (nonatomic, copy, nullable) NSString *version;
@property (nonatomic, copy, nullable) NSArray<AFSupplyChainNode *> *nodes;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

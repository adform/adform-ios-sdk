//
//  AFBidder.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFBidder : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *inventorySourceId;
@property (nonatomic, copy, nullable) NSString *masterTagName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

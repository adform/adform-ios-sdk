//
//  AFRequestVideoAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFRequestVideoAsset : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSArray<NSString *> *mimes;
@property (nonatomic, copy, nullable) NSNumber *minDuration;
@property (nonatomic, copy, nullable) NSNumber *maxDuration;
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *protocols;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

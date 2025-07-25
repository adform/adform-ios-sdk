//
//  AFNativeRequest.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

@class AFNativeRequestAsset;

NS_ASSUME_NONNULL_BEGIN

@interface AFNativeRequest : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *ver;
@property (nonatomic, copy, nullable) NSArray<AFNativeRequestAsset *> *assets;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

//
//  AFBrandVersion.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFBrandVersion : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *brand;
@property (nonatomic, strong, nullable) NSArray<NSString *> *version;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

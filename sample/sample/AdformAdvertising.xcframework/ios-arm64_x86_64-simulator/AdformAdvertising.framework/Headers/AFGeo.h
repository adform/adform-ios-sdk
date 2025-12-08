//
//  AFGeo.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFGeo : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *type;
@property (nonatomic, copy, nullable) NSNumber *latitude;
@property (nonatomic, copy, nullable) NSNumber *longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

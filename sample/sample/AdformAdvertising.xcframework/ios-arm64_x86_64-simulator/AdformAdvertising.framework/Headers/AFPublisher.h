//
//  AFPublisher.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFPublisher : NSObject <JSONConvertable>

@property (nonatomic, copy) NSString *rtbId;
@property (nonatomic, copy, nullable) NSString *domain;
@property (nonatomic, copy, nullable) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

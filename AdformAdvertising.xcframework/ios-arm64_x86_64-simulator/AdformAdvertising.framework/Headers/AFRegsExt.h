//
//  AFRegsExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFRequestDsaExt;

@interface AFRegsExt : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *gpp;
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *gppSid;
@property (nonatomic, copy, nullable) NSNumber *gdpr;
@property (nonatomic, strong, nullable) NSDictionary *dsa;
@property (nonatomic, copy, nullable) NSNumber *gpc;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

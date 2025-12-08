//
//  AFRegs.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFRegsExt;

@interface AFRegs : NSObject <JSONConvertable>

@property (nonatomic, strong, nullable) AFRegsExt *ext;
@property (nonatomic, copy, nullable) NSNumber *coppa;
@property (nonatomic, copy, nullable) NSString *gpp;
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *gppSid;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

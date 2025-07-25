//
//  AFUserExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

@class AFExtendedIdentifiers;

NS_ASSUME_NONNULL_BEGIN

@interface AFUserExt : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *consent;
@property (nonatomic, copy, nullable) NSArray<AFExtendedIdentifiers *> *extendedIds;
@property (nonatomic, copy, nullable) NSArray<NSDictionary<NSString*,NSString*> *> *keyValues;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

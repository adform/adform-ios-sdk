//
//  AFExtendedIdentifiers.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

@class AFExtendedIdentifier;

NS_ASSUME_NONNULL_BEGIN

@interface AFExtendedIdentifiers : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *source;
@property (nonatomic, copy, nullable) NSArray<AFExtendedIdentifier *> *ids;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

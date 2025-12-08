//
//  AFSource.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSourceExt;

@interface AFSource : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *transactionId;
@property (nonatomic, copy, nullable) NSNumber *finalDecision;
@property (nonatomic, strong, nullable) AFSourceExt *ext;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

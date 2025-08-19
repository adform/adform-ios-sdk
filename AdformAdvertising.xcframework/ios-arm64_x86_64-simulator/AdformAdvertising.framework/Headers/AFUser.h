//
//  AFUser.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFUserExt;
@class AFExtendedIdentifiers;

@interface AFUser : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *buyerUid;
@property (nonatomic, copy, nullable) NSString *keywords;
@property (nonatomic, copy, nullable) NSArray<AFExtendedIdentifiers *> *extendedIds;
@property (nonatomic, strong, nullable) AFUserExt *ext;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

//
//  AFSite.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFPublisher;
@class AFSiteExt;

@interface AFSite : NSObject <JSONConvertable>

@property (nonatomic, copy) NSString *rtbId;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *domain;
@property (nonatomic, copy, nullable) NSString *page;
@property (nonatomic, strong, nullable) AFPublisher *publisher;
@property (nonatomic, copy, nullable) NSNumber *mobile;
@property (nonatomic, copy, nullable) NSString *keywords;
@property (nonatomic, strong, nullable) AFSiteExt *ext;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

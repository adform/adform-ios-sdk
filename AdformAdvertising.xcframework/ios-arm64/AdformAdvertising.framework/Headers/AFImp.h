//
//  AFImp.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFBanner;
@class AFImpExt;
@class AFNative;
@class AFVideo;

@interface AFImp : NSObject <JSONConvertable>

@property (nonatomic, copy) NSString *rtbId;
@property (nonatomic, strong, nullable) AFBanner *banner;
@property (nonatomic, strong, nullable) AFNative *native;
@property (nonatomic, strong, nullable) AFVideo *video;
@property (nonatomic, copy, nullable) NSString *tagId;
@property (nonatomic, copy, nullable) NSNumber *interstitial;
@property (nonatomic, copy, nullable) NSNumber *bidFloor;
@property (nonatomic, copy, nullable) NSString *bidFloorCurrency;
@property (nonatomic, copy, nullable) NSNumber *secure;
@property (nonatomic, strong, nullable) AFImpExt *ext;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

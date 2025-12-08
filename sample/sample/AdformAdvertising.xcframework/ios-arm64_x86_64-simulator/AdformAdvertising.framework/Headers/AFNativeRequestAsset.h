//
//  AFNativeRequestAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFRequestDataAsset;
@class AFRequestImgAsset;
@class AFRequestTitleAsset;
@class AFRequestVideoAsset;

@interface AFNativeRequestAsset : NSObject <JSONConvertable>

@property (nonatomic, copy) NSString *rtbId;
@property (nonatomic, copy, nullable) NSNumber *required;
@property (nonatomic, strong, nullable) AFRequestTitleAsset *title;
@property (nonatomic, strong, nullable) AFRequestImgAsset *img;
@property (nonatomic, strong, nullable) AFRequestVideoAsset *video;
@property (nonatomic, strong, nullable) AFRequestDataAsset *data;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

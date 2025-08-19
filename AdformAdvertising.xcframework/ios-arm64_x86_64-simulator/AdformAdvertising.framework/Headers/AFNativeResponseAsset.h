//
//  AFNativeResponseAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFResponseTitleAsset;
@class AFResponseImgAsset;
@class AFResponseVideoAsset;
@class AFResponseDataAsset;

/**
 Represents an asset in a native OpenRTB response.
 */
@interface AFNativeResponseAsset : NSObject <JSONConvertable>

/** Corresponds to JSON "id" */
@property (nonatomic, copy, nullable) NSString *assetId;

/** Corresponds to JSON "required" */
@property (nonatomic, copy, nullable) NSNumber *required;

/** Corresponds to JSON "title" */
@property (nonatomic, strong, nullable) AFResponseTitleAsset *title;

/** Corresponds to JSON "img" */
@property (nonatomic, strong, nullable) AFResponseImgAsset *img;

/** Corresponds to JSON "video" */
@property (nonatomic, strong, nullable) AFResponseVideoAsset *video;

/** Corresponds to JSON "data" */
@property (nonatomic, strong, nullable) AFResponseDataAsset *data;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

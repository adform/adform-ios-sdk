//
//  AFResponseImgAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

typedef NS_ENUM(NSInteger, AFResponseImgAssetType) {
    
    AFResponseImgAssetTypeIcon = 1,
    
    AFResponseImgAssetTypeMainImage = 2,
    
    AFResponseImgAssetTypeOther = 999
};

NS_ASSUME_NONNULL_BEGIN

/**
 Represents an image asset in a native OpenRTB response.
 */
@interface AFResponseImgAsset : NSObject <JSONConvertable>

/** Corresponds to JSON "type" */
@property (nonatomic, copy, nullable) NSNumber *type;

/** Corresponds to JSON "url" */
@property (nonatomic, copy, nullable) NSString *url;

/** Corresponds to JSON "w" */
@property (nonatomic, copy, nullable) NSNumber *width;

/** Corresponds to JSON "h" */
@property (nonatomic, copy, nullable) NSNumber *height;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

- (AFResponseImgAssetType)getAssetType;

@end

NS_ASSUME_NONNULL_END

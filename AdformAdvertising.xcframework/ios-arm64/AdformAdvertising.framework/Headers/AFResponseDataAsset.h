//
//  AFResponseDataAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

typedef NS_ENUM(NSInteger, AFResponseDataAssetType) {
    
    AFResponseDataAssetTypeSponsoredBy = 1,
    
    AFResponseDataAssetTypeDescription = 2,
    
    AFResponseDataAssetTypeRating = 3,
    
    AFResponseDataAssetTypeSalePrice = 7,
    
    AFResponseDataAssetTypeCallToAction = 12,
    
    AFResponseDataAssetTypeOther = 999,
};

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a data asset in a native OpenRTB response.
 */
@interface AFResponseDataAsset : NSObject <JSONConvertable>

/** Corresponds to JSON "type" */
@property (nonatomic, copy, nullable) NSNumber *type;

/** Corresponds to JSON "len" */
@property (nonatomic, copy, nullable) NSNumber *len;

/** Corresponds to JSON "value" */
@property (nonatomic, copy, nullable) NSString *value;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

- (AFResponseDataAssetType)getAssetType;

@end

NS_ASSUME_NONNULL_END

//
//  AFNativeAdAssetIds.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFNativeAdAssetIds : NSObject

@property (nonatomic, copy, nullable) NSString *mainImageId;
@property (nonatomic, copy, nullable) NSString *appIconImageId;
@property (nonatomic, copy, nullable) NSString *descriptionId;
@property (nonatomic, copy, nullable) NSString *ctaId;
@property (nonatomic, copy, nullable) NSString *sponsoredById;
@property (nonatomic, copy, nullable) NSString *ratingId;
@property (nonatomic, copy, nullable) NSString *salePriceId;

@end

NS_ASSUME_NONNULL_END

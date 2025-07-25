//
//  AFNativeAd.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/AFResponseImgAsset.h>

@class AFNativeResponse;
@class AFNativeAdAssetIds;

NS_ASSUME_NONNULL_BEGIN

@interface AFNativeAd : NSObject

@property (nonatomic, strong) AFNativeResponse *nativeResponse;
@property (nonatomic, strong) AFNativeAdAssetIds *assetIds;

- (instancetype)initWithNativeResponse:(AFNativeResponse *)nativeResponse;
- (instancetype)initWithNativeResponse:(AFNativeResponse *)nativeResponse
                              assetIds:(AFNativeAdAssetIds *)assetIds;

/** * Records an impression for the ad.
 *
 * This method should be called when the ad is displayed to the user.
 * It is important to call this method to ensure proper tracking of ad impressions.
 */
- (void)recordImpression;

/**
 * Records a click for the ad.
 *
 * This method should be called when the user clicks on the ad.
 * It is important to call this method to ensure proper tracking of ad interactions.
 */
- (void)recordClick;

/**
 * Extracts ad title from assets.
 *
 * @return The ad title.
 */
- (NSString *)getTitle;

/**
 * Extracts description from assets.
 *
 * @return The description.
 */
- (NSString *)getDescription;

/**
 * Extracts main image url from assets.
 *
 * @return The image url.
 */
- (NSString *)getImageUrl;

/**
 * Downloads main image from the URL specified in assets and caches it.
 *
 * @param completion The completion block to be called when the download is complete.
 *                  If there was an error, it will be passed as an argument, otherwise it will be nil.
 */
- (void)downloadMainImageWithCompletion:(void(^)(NSError * _Nullable error))completion;

/**
 * Gets main image from cache if it was downloaded previously.
 *
 * @return The main image as UIImage, or nil if not available.
 */
- (nullable UIImage *)getCachedMainImage;

/**
 * Extracts call to action button title from assets.
 *
 * @return The call to action title.
 */
- (NSString *)getCallToAction;

/**
 * Extracts sponsored by text from assets.
 *
 * @return The string representing sponsored by text.
 */
- (NSString *)getSponsoredBy;

/**
 * Extracts icon url from assets.
 *
 * @return The icon url.
 */
- (NSString *)getIconUrl;

/**
 * Extracts sale price from assets.
 *
 * @return The sale price.
 */
- (NSString *)getSalePrice;

/**
 * Downloads icon image from the URL specified in assets and caches it.
 *
 * @param completion The completion block to be called when the download is complete.
 *                  If there was an error, it will be passed as an argument, otherwise it will be nil.
 */
- (void)downloadIconImageWithCompletion:(void(^)(NSError * _Nullable error))completion;

/**
 * Gets icon image from cache if it was downloaded previously.
 *
 * @return The icon image as UIImage, or nil if not available.
 */
- (nullable UIImage *)getCachedIconImage;

/**
 * Extracts star rating from assets if available.
 *
 * @return The star rating as a NSNumber, or nil if not available or not parseable.
 */
- (nullable NSDecimalNumber *)getStarRating;

/**
 * Checks if any asset has video content.
 *
 * @return true if any asset has video content, false otherwise.
 */
- (BOOL)hasVideoContentInAd;

@end

NS_ASSUME_NONNULL_END

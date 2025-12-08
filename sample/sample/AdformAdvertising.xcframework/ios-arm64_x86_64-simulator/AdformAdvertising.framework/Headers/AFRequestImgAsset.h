//
//  AFRequestImgAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFRequestImgAsset : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *type;
@property (nonatomic, copy, nullable) NSNumber *width;
@property (nonatomic, copy, nullable) NSNumber *widthMin;
@property (nonatomic, copy, nullable) NSNumber *height;
@property (nonatomic, copy, nullable) NSNumber *heightMin;
@property (nonatomic, copy, nullable) NSArray<NSString *> *mimes;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

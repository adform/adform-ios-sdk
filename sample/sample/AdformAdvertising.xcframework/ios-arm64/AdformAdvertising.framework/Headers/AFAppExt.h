//
//  AFAppExt.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFInstalledSDK;

@interface AFAppExt : NSObject <JSONConvertable>

@property (nonatomic, strong, nullable) AFInstalledSDK *installedSdk;
@property (nonatomic, copy, nullable) NSArray<NSDictionary<NSString*,NSString*> *> *keyValues;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

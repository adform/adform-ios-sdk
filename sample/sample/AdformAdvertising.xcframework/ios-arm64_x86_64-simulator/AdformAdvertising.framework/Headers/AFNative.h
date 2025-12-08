//
//  AFNative.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

@class AFNativeRequest;

NS_ASSUME_NONNULL_BEGIN

@class AFJsonObjectOrString<NativeRequest>;

@interface AFNative : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *ver;
@property (nonatomic, strong, nullable) AFNativeRequest *request;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

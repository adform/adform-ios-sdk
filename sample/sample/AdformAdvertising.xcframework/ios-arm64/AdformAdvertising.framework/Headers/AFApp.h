//
//  AFApp.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFAppExt;

@interface AFApp : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *bundle;
@property (nonatomic, copy, nullable) NSString *domain;
@property (nonatomic, copy, nullable) NSString *storeUrl;
@property (nonatomic, copy, nullable) NSString *version;
@property (nonatomic, copy, nullable) NSString *keywords;
@property (nonatomic, strong, nullable) AFAppExt *ext;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

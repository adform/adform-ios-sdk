//
//  AFAdLink.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents the link object in a native OpenRTB response.
 */
@interface AFAdLink : NSObject <JSONConvertable>

/** Corresponds to JSON "url" */
@property (nonatomic, copy, nullable) NSString *url;

/** Corresponds to JSON "clicktrackers" */
@property (nonatomic, copy, nullable) NSArray<NSString *> *clickTrackers;

/** Corresponds to JSON "fallback" */
@property (nonatomic, copy, nullable) NSString *fallback;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

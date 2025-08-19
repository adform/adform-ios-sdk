//
//  AFResponseTitleAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a title asset in a native OpenRTB response.
 */
@interface AFResponseTitleAsset : NSObject <JSONConvertable>

/** Corresponds to JSON "text" */
@property (nonatomic, copy, nullable) NSString *text;

/** Corresponds to JSON "len" */
@property (nonatomic, copy, nullable) NSNumber *len;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

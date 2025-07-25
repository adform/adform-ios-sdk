//
//  AFResponseVideoAsset.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a video asset in a native OpenRTB response.
 */
@interface AFResponseVideoAsset : NSObject <JSONConvertable>

/** Corresponds to JSON "vasttag" */
@property (nonatomic, copy, nullable) NSString *vastTag;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

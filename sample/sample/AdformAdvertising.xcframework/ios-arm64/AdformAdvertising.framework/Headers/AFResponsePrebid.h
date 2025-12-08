//
//  AFResponsePrebid.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents the prebid extension in an OpenRTB bid response.
 */
@interface AFResponsePrebid : NSObject <JSONConvertable>

/** Corresponds to JSON "type" */
@property (nonatomic, copy, nullable) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

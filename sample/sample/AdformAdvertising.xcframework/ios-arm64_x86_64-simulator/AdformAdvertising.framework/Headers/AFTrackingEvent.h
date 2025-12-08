//
//  AFTrackingEvent.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 06/19/25.
//  Copyright © 2025 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents an event tracker in a native OpenRTB response.
 */
@interface AFTrackingEvent : NSObject <JSONConvertable>

/** Corresponds to JSON "event" */
@property (nonatomic, copy, nullable) NSNumber *event;

/** Corresponds to JSON "method" */
@property (nonatomic, copy, nullable) NSNumber *method;

/** Corresponds to JSON "url" */
@property (nonatomic, copy, nullable) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

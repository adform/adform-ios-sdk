//
//  AFUserDataExt.h
//  AdformAdvertising
//
//  Created by Jaroslav on 17/10/2025.
//  Copyright © 2025 adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFUserDataExt : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSNumber *segtax;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

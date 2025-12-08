//
//  AFUserDataSegment.h
//  AdformAdvertising
//
//  Created by Jaroslav on 13/10/2025.
//  Copyright © 2025 adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFUserDataSegment : NSObject <JSONConvertable>

@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *ext;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *value;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

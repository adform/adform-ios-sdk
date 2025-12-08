//
//  AFUserData.h
//  AdformAdvertising
//
//  Created by Jaroslav on 10/10/2025.
//  Copyright © 2025 adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/JSONConvertable.h>

NS_ASSUME_NONNULL_BEGIN

@class AFUserDataSegment;
@class AFUserDataExt;

@interface AFUserData : NSObject <JSONConvertable>

@property (nonatomic, strong, nullable) AFUserDataExt *ext;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSArray<AFUserDataSegment *> *segment;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END

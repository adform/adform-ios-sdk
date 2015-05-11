//
//  AFAdHesion.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 27/04/15.
//  Copyright (c) 2015 adform. All rights reserved.
//

#import <AdformAdvertising/AdformAdvertising.h>

/**
 The AFAdHesion class provides a view container that displays sticky inline advertisements.
 
 You can use this class to place ad banners at the top or bottom of the screen.
 They are automatically positioned to be fully visible to the user
 and won't be obscured by navigation or tool bars (in case of extended view controller layout).
 */
@interface AFAdHesion : AFAdInline

/**
 Shows ad view position type.
 
 Default value - AFAdPositionBottom.
 
 @see AFAdPosition
 */
@property (nonatomic, assign, readonly) AFAdPosition position;

/**
 Initializes an AFAdHesion with the given master tag id and an ad position.
 
 @param mid An integer representing Adform master tag id.
 @param position Ad position.
 @param viewController The view controller which is presenting the ad view.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid position:(AFAdPosition )position presentingViewController:(UIViewController *)viewController;

/**
 Initializes an AFAdHesion with the given master tag id, an ad position and ad size.
 
 @param mid An integer representing Adform master tag id.
 @param position Ad position.
 @param viewController The view controller which is presenting the ad view.
 @param size Custom ad size.
 
 @return A newly initialized ad view.
 
 @warning Ad size cannot be less than 250x50.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid position:(AFAdPosition )position presentingViewController:(UIViewController *)viewController adSize:(CGSize )size;

@end

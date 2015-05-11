//
//  AFPageAdView.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 25/03/15.
//  Copyright (c) 2015 adform. All rights reserved.
//

#import "AFAdInline.h"

/**
 The AFAdInterstitial class provides a view container that displays in page advertisements.
 */
@interface AFAdInterstitial : AFAdInline

/**
 This property indicates if ad view is loaded.
 
 You should check this property before displaying the ad to see if it was already loaded.
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 Indicates if ad view was visible to the user at least once.
 AFAdInterstitial can be reloaded only after being displayed to the user.
 Therefore, youcan check this property to see if ad was displayed to the user and it can be reloaded.
 */
@property (nonatomic, assign, readonly, getter=wasDisplayed) BOOL displayed;

/**
 Initializes a new AFAdView.
 
 You should use this initialization method to create AFPageAdView objects.
 
 @param frame Page ad view frame.
 @param mid An integer representing Adform master tag id.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithFrame:(CGRect )frame masterTagId:(NSInteger)mid presentingViewController:(UIViewController *)viewController;

@end
//
//  AFPageViewControllerDatasource.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 30/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdformAdvertising/AdformAdvertising.h>

@protocol AFPageViewControllerMediatorDelegate;

/**
 This is a helper class designed to ease the implementation of interstitial ads inside page view controller.
 
 First setup an UIPageViewController, assign him datasource and delegate.
 Then create a AFPageViewControllerMediator class object, set master tad id, ad frequesncy and pass him UIPageViewController object reference.
 Thats it, mediator will take care of everything else.
 */
@interface AFPageViewControllerMediator : NSObject 

/**
 A reference to the UIPageViewController which is used to display page ads.
 */
@property (nonatomic, weak) UIPageViewController *pageViewController;

/**
 The delegate object.
 
 Methods are called to provide control over ad display.
 
 @see AFPageViewControllerMediatorDelegate
 */
@property (nonatomic, weak) id <AFPageViewControllerMediatorDelegate> delegate;

/**
 AFPageViewControllerMediator uses only one instance of AFAdInterstitial. You cannot acces it directly, but you can set the 'adViewDelegate' property of the mediator
 to be informed about the state changes of that ad view.
 
 @see AFAdInlineDelegate
 */
@property (nonatomic, weak) id <AFAdInlineDelegate> adViewDelegate;

/**
 Ad frequency determines how often ad views are displayed to the user.
 
 If you implement AFPageViewControllerMediatorDelegate protocol this property is ignored.
 
 For example, if you set adFrequency = 3, it means that at least 3 normal pages will be displayed before ad view.
 
 Default value - 3.
 */
@property (nonatomic, assign) NSInteger adFrequency;

/**
 Initializes an AFPageViewControllerMediator with the given master tag id.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid;

/**
 Initializes an AFPageViewControllerMediator with additional parameters.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 @param adFrequency The frequecy of the page ad views.
 @param pageViewController A page view controller used to display ads.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid
                        adFrequency:(NSInteger )adFrequency
                 pageViewController:(UIPageViewController *)pageViewController;

/**
 Initializes an AFPageViewControllerMediator with additional parameters.
 
 Master tag id is used to initialize AFPageAdView.
 
 @param mid An integer representing Adform master tag id.
 @param pageViewController A page view controller used to display ads.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid
                 pageViewController:(UIPageViewController *)pageViewController;

/**
 This method resets the internal page views counter, i.e. the next ad view will be displayed after the number of pages set in 'adFrequency" property.
 */
- (void)reset;

/**
 @return Previouslly displayed view controller.
 */
- (UIViewController *)previousViewController;

@end

@protocol AFPageViewControllerMediatorDelegate <NSObject>

@optional
/**
 Used to determine if ad should be displayed after view controller.
 
 This method gets caled when user is scrolling to right/down direction.
 
 @param mediator A page view controller mediator calling the method.
 @param viewController The view controller after which an ad should be displayed.
 
 @return A boolean value indicating if ad should be displayed after the view controller.
 */
- (BOOL)pageViewControllerMediator:(AFPageViewControllerMediator *)mediator shouldShowAdAfterViewController:(UIViewController *)viewController;

/**
 Used to determine if ad should be displayed before view controller.
 
 This method gets called when user is scrolling to left/up direction.
 
 @param mediator A page view controller mediator calling the method.
 @param viewController The view controller after which an ad should be displayed.
 
 @return A boolean value indicating if ad should be displayed after the view controller.
 */
- (BOOL)pageViewControllerMediator:(AFPageViewControllerMediator *)mediator shouldShowAdBeforeViewController:(UIViewController *)viewController;

@end

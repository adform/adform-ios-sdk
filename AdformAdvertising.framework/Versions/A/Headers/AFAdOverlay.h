//
//  AFAdOverlay.h
//  AdformAdvertising
//
//  Copyright (c) 2014 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFConstants.h"

@protocol AFAdOverlayDelegate;

/**
 The AFAdOverlay class provides a controller that displays overlay advertisements.
 */
@interface AFAdOverlay : NSObject

/**
 The object implementing AFAdOverlayDelegate protocol, which is notified about banner state changes.
 */
@property (nonatomic, weak) id<AFAdOverlayDelegate> delegate;

/**
 Required reference to the view controller which is presenting the overlay ad.
 Don't assign this property directly, instead use 'showFromViewController:' method, which assigns it automatically.

 @see showFromViewController:
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 This property determines how overlay ad display should be animated.
 
 You can also set this property to AFModalPresentationStyleNone to display overlay ads without animations.
 
 Default value - AFModalPresentationStyleFadeInOut. For available values check AFModalPresentationStyle enum.
 
 @see AFModalPresentationStyle
 */
@property (nonatomic, assign) AFModalPresentationStyle presentationStyle;

/**
 This property determines if application content should be dimmed when displaying a modal view.
 
 Default value - YES.
 */
@property (nonatomic, assign, getter=isDimOverlayEnabled) BOOL dimOverlayEnabled;

/**
 Property indicating if ad view is viewable by user.
 */
@property (nonatomic, assign, readonly, getter = isViewable) BOOL viewable;

/**
 Property indicating if ad is loaded.
 */
@property (nonatomic, assign, readonly, getter = isLoaded) BOOL loaded;

/**
 Shows ad view state.
 
 For available values check AFAdState enum.
 
 @see AFAdState
 */
@property (nonatomic, assign, readonly) AFAdState state;

/**
 Custom impression url, which is fired when an ad is loaded.
 */
@property (nonatomic, strong) NSURL *customImpression;

/**
 Turns on/off debug mode.
 
 Default value - NO.
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 You can add an array of keywords to identify the placement,
 this way the Adform will be able to target ads to your users even more accurately, e.g. @[@"music", @"rock", @"pop"].
 
 @warning This value should be set before loading the ad view,
 if it is set after calling the "loadAd" method this data won't be sent to our server.
 If you want to change this data after loading the ad view, you should create a new ad view with updated data.
 */
@property (nonatomic, strong) NSArray *keywords;

/**
 You can add custom key-value pair data to identify the placement,
 this way the Adform will be able to target ads to your users even more accurately, e.g. @{@"content": @"music"}.
 
 @warning This value should be set before loading the ad view,
 if it is set after calling the "loadAd" method this data won't be sent to our server.
 If you want to change this data after loading the ad view, you should create a new ad view with updated data.
 */
@property (nonatomic, strong) NSDictionary *keyValues;

/**
 Initializes an AFAdOverlay with the given master tag id.
 
 @param mid An integer representing Adform master tag id.
 @return A newly initialized overlay ad controller.
 */
- (instancetype)initWithMasterTagID:(NSInteger )mid;

/**
 Loads an ad if needed and displays it in an overlay ad view.
 
 If you want to control the exact time when overlay ad is shown, you should preload the ad in advance using the method preloadAd, before calling show.
 
 @param viewController View controller which is presenting the overlay ad view, cannot be nil.
 */
- (void)showFromViewController:(UIViewController *)viewController;

/**
 Preloads an ad in advance.
 
 You can use this method to control the precise tme when the ad will be displayed. First, preload an ad. Then, after the loading is complete you can display the ad with the 'showFromViewController:' method.
 */
- (void)preloadAd;

@end

/**
 The delegate of an AFAdOverlay object must adopt the AFAdOverlayDelegate protocol.
 
 This protocol has optional methods which allow the delegate to be notified of overlay ad lifecycle and state change events.
 */
@protocol AFAdOverlayDelegate <NSObject>

@optional

/**
 Gets called when an AFAdOverlay successfully loads.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayDidLoadAd:(AFAdOverlay *)adOverlay;

/**
 Gets called when an AFAdOverlay fails to load an ad.
 
 @param adOverlay An overlay ad view object calling the method.
 @param error An error indicating what went wrong.
 */
- (void)adOverlayDidFailToLoadAd:(AFAdOverlay *)adOverlay withError:(NSError *)error;

/**
 Gets called when an AFAdOverlay is about to show.
 This method is called before the animation begins.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayWillShow:(AFAdOverlay *)adOverlay;

/**
 Gets called when an AFAdOverlay has been shown.
 This method is called after the show animation.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayDidShow:(AFAdOverlay *)adOverlay;

/**
 Gets called when an AFAdOverlay is about to be dismissed.
 This method is called before the animation.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayWillHide:(AFAdOverlay *)adOverlay;

/**
 Gets called when an AFAdOverlay has been dismissed.
 This method is called after the animation.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayDidHide:(AFAdOverlay *)adOverlay;

/**
 Gets called when an ad is about to open in external browser.
 The application is going to be moved to background after this method gets called.
 
 @param adOverlay An overlay ad view object calling the method.
 */
- (void)adOverlayWillOpenExternalBrowser:(AFAdOverlay *)adOverlay;

@end

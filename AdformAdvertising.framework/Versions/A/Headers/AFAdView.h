//
//  AFAdView.h
//  AdformAdvertising
//
//  Copyright (c) 2014 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Ad view animation duration, use it to match content animation with ad view animations.
 */
extern const CGFloat kAdViewAnimationDuration;

/**
 Default ad size for iPhone - 320x50.
 */
extern const CGSize kDefaultIphoneAdSize;

/**
 Default ad size for iPad - 728x90.
 */
extern const CGSize kDefaultIpadAdSize;

/**
 Ad view state values.
 */
typedef enum {
    AFAdViewStateVisible = 0,   /** Ad view is visible and showing an ad. */
    AFAdViewStateHidden,        /** Ad view is hidden and no ad is being shown. */
    AFAdViewStateInTransition   /** Ad view is transitioning from one state to another. */
} AFAdViewState;

/**
 Ad view position.
 */
typedef enum {
    AFAdViewPositionTop = 0,    /** Ad view is positioned at the top of superview, centered. */
    AFAdViewPositionBottom,     /** Ad view is positioned at the bottom of superview, centered. */
    AFAdViewPositionCustom      /** Ad view is positioned at custom location. By default ad view autoresizeMask is (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin) */
} AFAdViewPosition;

@protocol AFAdViewDelegate;

/**     
 The AFAdView class provides a view container that displays inline advertisements.
 */
@interface AFAdView : UIView

/**
 The object implementing AFAdViewDelegate protocol, which is notified about ad view state changes.
 */
@property (nonatomic, assign) id<AFAdViewDelegate> delegate;

/**
 Ad view size shows the size of the ad placement. 
 This property can differ from frame.size when ad view hasn't loaded any ads, when an ad view loads an ad its frame.size becomes equal to adSize.
 You can set this property to use custom size ads.
 
 Default values: iPhone - 320x50, iPad - 728x90.
 
 Ad size cannot be less than: 250x50.
 */
@property (nonatomic, assign) CGSize adSize;

/**
 Required reference to the view controller which is presenting the ad view.
 
 You should set this property when you are creating an ad view instance.
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 Shows ad view state.
 
 For available values check AFAdViewState enum.
 */
@property (nonatomic, assign, readonly) AFAdViewState state;

/**
 Shows ad view position type.
 
 For available values check AFAdViewPosition enum.
 
 Default position - AFBAdVIewPositionBottom.
 */
@property (nonatomic, assign, readonly) AFAdViewPosition position;

/**
 Property indicating if ad view is viewable by user.
 */
@property (nonatomic, assign, readonly, getter = isViewable) BOOL viewable;

/**
 Turns on/off debug mode.
 
 Default value - NO.
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 Custom impression url. which is fired when ad is loaded.
 */
@property (nonatomic, strong) NSURL *customImpression;

/**
 Initializes an AFAdView with the given master tag id.
 
 @param mid An integer representing Adform master tag id.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid;

/**
 Initializes an AFAdView with the given master tag id and an ad view position type.
 
 @param mid An integer representing Adform master tag id.
 @param position Ad view position.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid position:(AFAdViewPosition )position;

/**
 Initializes an AFAdView with the given master tag id and an ad view position type.
 
 @param mid An integer representing Adform master tag id.
 @param position Ad view position.
 @param size Custom ad size, cannot be less than 250x50.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid position:(AFAdViewPosition )position adSize:(CGSize )size;

/**
 Initiates advertisement loading.
 */
- (void)loadAd;

/**
 Returns default ad size depending on iOS platform you are using (iPad or iPhone)
 */
+ (CGSize )defaultAdSize;

@end

/**
 The delegate of an AFAdView object must adopt the AFAdViewDelegate protocol.
 
 This protocol has optional methods which allow the delagate to be notified of ad view lifecycle and state change events.
 */
@protocol AFAdViewDelegate <NSObject>

@optional

/**
 Gets called when an AFAdView successfully loads or reloads an ad.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewDidLoadAd:(AFAdView *)adView;

/**
 Gets called when an AFAdView fails to loads or reload an ad.
 
 You will receive an error with code -997 when everyting whent ok, but there was no ad to be shown at the moment.
 
 @param adView An ad view object calling the method.
 @param error An error indicating what went wrong.
 */
- (void)adViewDidFailToLoadAd:(AFAdView *)adView withError:(NSError *)error;

/**
 Gets called when an AFAdView is about to be shown.
 This method is called before the ad view animation starts.
 Use adSize property to determen ad view size, because ad view frame and bounds are not set at this moment.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewWillShow:(AFAdView *)adView;

/**
 Gets called when an ad view is about to be hidden.
 This method is called before the ad view animation.
 It is recomended to use adSize, not frame or bounds, property to determen ad view size.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewWillHide:(AFAdView *)adView;

/**
 Gets called when an ad view is about to present a modal view with advertisement.
 This method is called when the modal view controller is about to be presented after the user has pressed the ad.
 You should stop application activity in topmost view controller at this point.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewWillPresentModalView:(AFAdView *)adView;

/**
 Gets called when an ad view is about to dissmis previously shown modal view with advertisement.
 You should use this method to resume any application activity you stopped in [adViewWillPresentModalView:] method.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewWillDismissModalView:(AFAdView *)adView;

/**
 Gets called when an ad is about to open in external browser.
 The application is going to be moved to background after this method gets called.
 
 @param adView An ad view object calling the method.
 */
- (void)adViewWillOpenExternalBrowser:(AFAdView *)adView;

@end
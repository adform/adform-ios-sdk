//
//  AdformBannerView.h
//  AdformSample
//
//  Created by Vladas on 23/04/14.
//  Copyright (c) 2014 adform. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Banner animation duration, use it to match content animation with banner.
 */
#define kBannerAnimationDuration 0.5

/**
 Banner view state values.
 */
typedef enum {
    AFBannerStateVisible = 0,   /** Banner view is visible and showing an ad. */
    AFBannerStateHidden,        /** Banner view is hidden and no ad is being shown. */
    AFBannerStateTransition     /** Banner view is transitioning from one state to another. */
} AFBannerState;

/**
 Banner view position
 */
typedef enum {
    AFBannerPositionTop = 0,    /** Banner view is positioned at the top of superview, centered. */
    AFBannerPositionBottom,     /** Banner view is positioned at the bottom of superview, centered. */
    AFBannerPositionCustom      /** Banner view is positioned at custom location. By default banner autoresizeMask is (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin) */
} AFBannerPosition;

@protocol AFBannerViewDelegate;

/**     
 The AFBannerView class provides a view container that displays inline advertisements.
 */
@interface AFBannerView : UIView

/**
 The object implementing AFBannerViewDelegate protocol, which is notified about banner state changes.
 */
@property (nonatomic, assign) id<AFBannerViewDelegate> delegate;
/**
 Shows banner view state. For available values check AFBannerState.
 */
@property (nonatomic, assign, readonly) AFBannerState state;

@property (nonatomic, assign, readonly) CGSize bannerSize;

/**
 Default position - AFBannerPositionBottom.
 */
@property (nonatomic, assign, readonly) AFBannerPosition position;

/**
 Property indicating if ad view is viewable by user.
 */
@property (nonatomic, assign, getter = isViewable) BOOL viewable;

/**
 You can add custom key-value pair data to target ads to your users even more accurately, e.g. @{@"gender": @"male"}.
 Be sure to set customData before calling loadAd method, because otherwise this data will be used only on banner refresh.
 */
//@property (nonatomic, strong) NSDictionary *customData;

/**
 Initializes an AFBannerView with the given ad unit id.
 
 @param mid An integer representing Adform master tag id.
 @return A newly initialized ad banner view.
 */
- (id)initWithMasterTagId:(NSInteger )mid;

/**
 Initializes an AFBannerView with the given ad unit id.
 
 @param mid An integer representing Adform master tag id.
 @param position Banner view position.
 @return A newly initialized ad banner view.
 */
- (id)initWithMasterTagId:(NSInteger )mid position:(AFBannerPosition )position;

/**
 Initiates advertisement loading.
 */
- (void)loadAd;

/**
 Returns expexcted banner size depending on iOS platform you are using (iPad or iPhone)
 */
+ (CGSize )expectedBannerSize;

@end

/**
 The delegate of an AFBannerView object must adopt the AFBannerViewDelegate protocol. 
 
 This protocol has optional methods which allow the delagate to be notified of banner lifecycle and state change events.
 */
@protocol AFBannerViewDelegate <NSObject>

@optional

/**
 Gets called when an AFBannerView successfully loads or reloads an ad.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewDidLoadAd:(AFBannerView *)bannerView;

/**
 Gets called when an AFBannerView fails to loads or reload an ad.
 
 Banner may hide without calling this method, if no error accure and server decides to return no ad.
 
 @param bannerView A banner view object calling the method.
 @param error An error indicating what went wrong.
 */
- (void)bannerViewDidFailToLoadAd:(AFBannerView *)bannerView withError:(NSError *)error;

/**
 Gets called when an AFBannerView successfully loads first advertisement.
 This method is called before the banner animation.
 Use bannerSize property to determen banner size, because banner frame and bounds are not set at this moment.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewWillShow:(AFBannerView *)bannerView;

/**
 Gets called when a banner view has no ad to show after refresh.
 This method is called before the banner animation.
 It is recomended to use bannerSize, not frame or bounds, property to determen banner size.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewWillHide:(AFBannerView *)bannerView;

/**
 Gets called when a banner view chages size.
 This method is called before the banner animation.
 Your implementation of this method should resize the content view to fit with banner. Useful for running smooth animations.
 
 @param bannerView A banner view object calling the method.
 @param fromSize The size the banner is resizing from.
 @param toSize The size the banner is resizing to.
 */
- (void)bannerView:(AFBannerView *)bannerView willResizeFromSize:(CGSize )fromSize toSize:(CGSize )toSize;

/**
 Gets called when a banner view chages size.
 This method is called after the banner animation.
 Your implementation of this method should resize the content view to fit with banner.
 
 @param bannerView A banner view object calling the method.
 @param fromSize The size the banner is resizing from.
 @param toSize The size the banner is resizing to.
 */
- (void)bannerView:(AFBannerView *)bannerView didResizeFromSize:(CGSize )fromSize toSize:(CGSize )toSize;

/**
 Gets called when a banner view is about to present a modal view with advertisement.
 This method is called when the modal view controller is about to be presented after the user has pressed the ad. 
 You should stop application activity in topmost view controller at this point.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewWillPresentModalView:(AFBannerView *)bannerView;

/**
 Gets called when a banner view is about to dissmis previously shown modal view with advertisement.
 You should use this method to resume any application activity you stopped in "willPresentModalViewForBannerView" method.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewWillDismissModalView:(AFBannerView *)bannerView;

/**
 Gets called when an ad is about to open in external browser.
 The application is going to be moved to background after this method gets called.
 
 @param bannerView A banner view object calling the method.
 */
- (void)bannerViewWillOpenExternalBrowser:(AFBannerView *)bannerView;

@end
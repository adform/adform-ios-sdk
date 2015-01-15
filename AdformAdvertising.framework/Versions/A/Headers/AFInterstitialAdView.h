//
//  AFInterstitialAdView.h
//  AdformAdvertising
//
//  Copyright (c) 2014 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFInterstitialAdViewDelegate;

/**
 The AFInterstitialAdView class provides a view container that displays interstitial advertisements.
 */
@interface AFInterstitialAdView : UIView

/**
 Property indicating if ad view is viewable by user.
 */
@property (nonatomic, assign, readonly, getter = isViewable) BOOL viewable;

/**
 Property indicating if ad is loaded.
 */
@property (nonatomic, assign, readonly, getter = isLoaded) BOOL loaded;

/**
 The object implementing AFInterstitialAdViewDelegate protocol, which is notified about banner state changes.
 */
@property (nonatomic, assign) id<AFInterstitialAdViewDelegate> delegate;

/**
 Required reference to the view controller which is presenting the interstitial ad view.
 Don't assign this property directly, instead use showFromViewController:animated: method, which assings it automatically.
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 Custom impression url. which is fired when ad is loaded.
 */
@property (nonatomic, strong) NSURL *customImpression;

/**
 Turns on/off debug mode.
 
 Default value - NO.
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 Initializes an AFInterstitialAdView with the given master tag id.
 
 @param mid An integer representing Adform master tag id.
 @return A newly initialized interstitial ad view.
 */
- (id)initWithMasterTagID:(NSInteger )mid;

/**
 Loads an ad if needed and displays it in an interstitial ad view.
 
 If you want to controll the exact time when interstitial ad is shown, you should preload the ad in advance using the method preloadAd, before calling show.
 
 @param viewController View controller which is presenting the interstitial ad view, cannot be nil.
 @param animated Boolean value indicating if interstitial ad view should be displayed with animation.
 */
- (void)showFromViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 Loads an ad in advance, to be able to display interstitial ad instantly. After the loading is compleate you can display the ad with show method.
 You can use this method to preload an ad.
 */
- (void)preloadAd;

@end

/**
 The delegate of an AFInterstitialAdView object must adopt the AFInterstitialAdViewDelegate protocol.
 
 This protocol has optional methods which allow the delagate to be notified of interstitial ad lifecycle and state change events.
 */
@protocol AFInterstitialAdViewDelegate <NSObject>

@optional

/**
 Gets called when an AFInterstitialAdView successfully loads.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewDidLoadAd:(AFInterstitialAdView *)interstitialAdView;

/**
 Gets called when an AFInterstitialAdView fails to laod an ad.
 
 You will receive an error with code -997 when everyting whent ok, but there was no ad to be shown at the moment.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 @param error An error indicating what went wrong.
 */
- (void)interstitialAdViewDidFailToLoadAd:(AFInterstitialAdView *)interstitialAdView withError:(NSError *)error;

/**
 Gets called when an AFInterstitialAdView is about to show.
 This method is called before the animation begins.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewWillShow:(AFInterstitialAdView *)interstitialAdView;

/**
 Gets called when an AFInterstitialAdView has been shown.
 This method is called after the show animation.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewDidShow:(AFInterstitialAdView *)interstitialAdView;

/**
 Gets called when an AFInterstitialAdView is about to be dismissed.
 This method is called before the animation.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewWillHide:(AFInterstitialAdView *)interstitialAdView;

/**
 Gets called when an AFInterstitialAdView has been dismissed.
 This method is called after the animation.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewDidHide:(AFInterstitialAdView *)interstitialAdView;

/**
 Gets called when an ad is about to open in external browser.
 The application is going to be moved to background after this method gets called.
 
 @param interstitialAdView An interstitial ad view object calling the method.
 */
- (void)interstitialAdViewWillOpenExternalBrowser:(AFInterstitialAdView *)interstitialAdView;

@end

//
//  AdFormInterstitialViewController.h
//  AdformSample
//
//  Created by Vladas on 23/04/14.
//  Copyright (c) 2014 adform. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFInterstitialAdViewDelegate;

/**
 The AFInterstitialAdView class provides a view container that displays interstitial advertisements.
 */
@interface AFInterstitialAdView : UIView

/**
 The object implementing AFBannerViewDelegate protocol, which is notified about banner state changes.
 */
//@property (nonatomic, assign) id<AFBannerViewDelegate> delegate;

/**
 Property indicating if ad view is viewable by user.
 */
@property (nonatomic, assign, getter = isViewable) BOOL viewable;

/**
 Property indicating if ad is loaded.
 */
@property (nonatomic, assign, readonly, getter = isLoaded) BOOL loaded;

/**
 The object implementing AFBannerViewDelegate protocol, which is notified about banner state changes.
 */
@property (nonatomic, assign) id<AFInterstitialAdViewDelegate> delegate;

/**
 You can add custom key-value pair data to target ads to your users even more accurately, e.g. @{@"gender": @"male"}.
 Be sure to set customData before calling loadAd method, because otherwise this data will be used only on banner refresh.
 */
//@property (nonatomic, strong) NSDictionary *customData;

/**
 Initializes an AFInterstitialAdView with the given ad unit id.
 
 @param mid An integer representing Adform master tag id.
 @return A newly initialized interstitial ad view.
 */
- (id)initWithMasterTagID:(NSInteger )mid;

/**
 Loads an ad if needed and displays it in an interstitial ad view.
 If you want to controll the exact time when interstitial ad is shown, you should preload the ad in advance using the method preloadAd, before calling show.
 */
- (void)show;

/**
 Loads an ad in advance, to be able to display interstitial ad instantly.
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

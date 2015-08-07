//
//  AFAdInline.h
//  AdformAdvertising
//
//  Copyright (c) 2014 Adform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFConstants.h"

@protocol AFAdInlineDelegate;

@class AFVideoSettings;

/**     
 The AFAdInline class provides a view container that displays inline advertisements.
 */
@interface AFAdInline : UIView

/**
 The object implementing AFAdInlineDelegate protocol, which is notified about the ad view state changes.
 */
@property (nonatomic, assign) id<AFAdInlineDelegate> delegate;

/**
 Ad view size shows the size of the ad placement. 
 
 This property can differ from frame.size when ad view hasn't loaded any ads.
 When an ad view loads an ad its frame.size becomes equal to adSize.
 You can set this property to use custom size ads.
 
 Default values: iPhone - 320x50, iPad - 728x90.
 
 @warning Ad size cannot be less than: 250x50.
 */
@property (nonatomic, assign) CGSize adSize;

/**
 This property determines what kind of banners should be loaded and displayed inside of the ad placement.
 By default ad placements load HTML banners (AFHTMLBanners type). If you want to load video ads,
 you must set this property to AFVideoBanners.
 
 Default value: AFHTMLBanners.
 
 @see AFAdContentType
 */
@property (nonatomic, assign) AFAdContentType adContentType;

/**
 This property determines how an ad transition should be animated inside the ad view.
 You can also set this property to AFAdTransitionStyleNone to disable ad view animations.
 
 Default value - AFAdTransitionStyleSlide.
 
 @see AFAdTransitionStyle
 */
@property (nonatomic, assign) AFAdTransitionStyle adTransitionStyle;

/**
 This property determines how expanded ads should be animated.
 You can also set this property to AFModalPresentationStyleNone to disable modal presentation animations.
 
 Default value - AFModalPresentationStyleSlide.
 
 @see AFModalPresentationStyle
 */
@property (nonatomic, assign) AFModalPresentationStyle modalPresentationStyle;

/**
 This property determines if application content should be dimmed when displaying a modal view.
 
 Default value - YES.
 */
@property (nonatomic, assign, getter=isDimOverlayEnabled) BOOL dimOverlayEnabled;

/**
 If you are using the ad view to display video advertisment, you can use this property to setup 
 video player behavior.
 */
@property (nonatomic, strong, readonly) AFVideoSettings *videoSettings;

/**
 Required reference to the view controller which is presenting the ad view.
 
 You should set this property when you are creating an ad view instance.
 
 @warning Ads will not be loaded if this property is not set.
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 Turns on/off debug mode.
 
 Default value - NO (debug mode turned off).
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 Custom impression url.
 This impression is fired when an ad is loaded.
 */
@property (nonatomic, strong) NSURL *customImpression;

/**
 This property determines if ad should be expand automatically after the first successfull load.
 You can use this flag to first load the ad and them show it (expand it) manually by calling 'showAd' method.
 Default value - YES.
 */
@property (nonatomic, assign) BOOL showAdAutomatically;

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
 Indicates ad view state.
 
 For available values check AFAdState enum.
 
 @see AFAdState
 */
@property (nonatomic, assign, readonly) AFAdState state;

/**
 Property indicating if ad view is viewable by the user.
 */
@property (nonatomic, assign, readonly, getter = isViewable) BOOL viewable;

/**
 A property identifying if an ad has been loaded.
 
 This property is set to YES after the first successful ad request.
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 Initializes an AFAdInline with the given master tag id.
 
 @param mid An integer representing Adform master tag id.
 @param viewController The view controller which is presenting the ad view.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid presentingViewController:(UIViewController *)viewController;

/**
 Initializes an AFAdInline with the given master tag id, an ad view position and ad size.
 
 @param mid An integer representing Adform master tag id.
 @param viewController The view controller which is presenting the ad view.
 @param size Custom ad size, cannot be less than 250x50.
 
 @return A newly initialized ad view.
 */
- (instancetype)initWithMasterTagId:(NSInteger )mid presentingViewController:(UIViewController *)viewController adSize:(CGSize )size;

/**
 Initiates advertisement loading.
 
 Ads are displayed automatically when loading finishes.
 You can use AFAdInlineDelegate protocol to track ad loading state.
 */
- (void)loadAd;

/**
 Shows (expands) the ad.
 
 If you are setting 'showAdAutomatically' property to NO, then you must use this method to display the ad manually after the succesful load.
 You can callthis method only when ad has finished loading. You can check this by waiting for a delegate callback 'adInlineDidLoadAd:',
 or by checking the 
 */
- (void)showAd;

/**
 Returns default ad size depending on iOS platform you are using (iPad or iPhone).
 */
+ (CGSize )defaultAdSize;

@end

/**
 The delegate of an AFAdInline object must adopt the AFAdInlineDelegate protocol.
 
 This protocol has optional methods which allow the delegate to be notified of the ad view lifecycle and state change events.
 */
@protocol AFAdInlineDelegate <NSObject>

@optional

/**
 Gets called when an AFAdInline successfully loads or reloads an ad.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineDidLoadAd:(AFAdInline *)adInline;

/**
 Gets called when an AFAdInline fails to loads or reload an ad.
 
 @param adInline An ad view object calling the method.
 @param error An error indicating what went wrong.
 */
- (void)adInlineDidFailToLoadAd:(AFAdInline *)adInline withError:(NSError *)error;

/**
 Gets called when an AFAdInline is about to be shown.
 
 This method is called before the ad view animation starts.
 Use adSize property to determine ad view size, because ad view frame and bounds are not set at this moment.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineWillShow:(AFAdInline *)adInline;

/**
 Gets called when an ad view is about to be hidden.
 
 This method is called before the ad view animation.
 It is recommended to use adSize, not frame or bounds, property to determine ad view size.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineWillHide:(AFAdInline *)adInline;

/**
 Gets called when an ad view is about to present a modal view with advertisement.
 
 This method is called when the modal view controller is about to be presented after the user has pressed the ad.
 You should stop application activity in topmost view controller at this point.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineWillPresentModalView:(AFAdInline *)adInline;

/**
 Gets called when an ad view is about to dismiss previously shown modal view with advertisement.
 
 You should use this method to resume any application activity you stopped in 'adInlineWillPresentModalView:' method.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineWillDismissModalView:(AFAdInline *)adInline;

/**
 Gets called when an ad is about to be opened in external browser.
 
 @warning The application is going to be moved to background after this method gets called.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineWillOpenExternalBrowser:(AFAdInline *)adInline;

/**
 Gets called when an ad view has started playing a video advertisement.
 
 @param adInline An ad view object calling the method.
 @param muted Identifies if video ad is muted.
 */
- (void)adInlineSartedVideoPlayback:(AFAdInline *)adInline muted:(BOOL )muted;

/**
 Gets called when an ad view has finished playing a video advertisement.
 
 @param adInline An ad view object calling the method.
 */
- (void)adInlineFinishedVideoPlayback:(AFAdInline *)adInline;

/**
 Gets called when a user has muted or unmuted the video advertisement.
 
 @param adInline An ad view object calling the method.
 @param muted Boolean value indicating if user has muted or unmuted the video ad.
 */
- (void)adInline:(AFAdInline *)adInline videoAdMuted:(BOOL )muted;

@end
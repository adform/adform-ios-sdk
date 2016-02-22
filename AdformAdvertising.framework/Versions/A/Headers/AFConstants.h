//
//  AFConstants.h
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 25/02/15.
//  Copyright (c) 2015 adform. All rights reserved.
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
typedef NS_ENUM (NSInteger, AFAdState) {
    /// Ad view is visible and showing an ad.
    AFAdStateVisible,
    
    /// Ad view is hidden and no ad is being shown.
    AFAdStateHidden,
    
    /// Ad view is being displayed.
    AFAdStateInShowTransition,
    
    /// Ad view is being hidden.
    AFAdStateInHideTransition
};

/**
 Ad view position.
 */
typedef NS_ENUM (NSInteger, AFAdPosition) {
    /// Ad view is positioned at the top of superview, centered.
    AFAdPositionTop,
    
    /// Ad view is positioned at the bottom of superview, centered.
    AFAdPositionBottom,
    
    /// Default ad view position - AFAdPositionBottom.
    AFAdPositionDefault
};

/**
 Ad transition animation style values.
*/
typedef NS_ENUM (NSInteger, AFAdTransitionStyle) {
    /// New ads slide up.
    AFAdTransitionStyleSlide,
    
    /// New ads fade in.
    AFAdTransitionStyleFade,
    
    /// Ad transition is not animated.
    AFAdTransitionStyleNone
};

/**
 Modal view presentation animation style values.
 */
typedef NS_ENUM (NSInteger, AFModalPresentationStyle) {
    /// When the modal view is presented, it slides up from the bottom of the screen.
    AFModalPresentationStyleSlide,
    
    /// When the modal view is presented, it fades in.
    AFModalPresentationStyleFadeInOut,
    
    /// Presentation is not animated.
    AFModalPresentationStyleNone
};

/**
 Ad view content type values.
 */
typedef NS_ENUM(NSInteger, AFAdContentType) {
    /// Ad placement will display HTML banners.
    AFHTMLBanners,
    // Ad placement will display video banners.
    AFVideoBanners
};

/// Adform Advertising SDK error domain.
extern NSString *const kAFErrorDomain;

/**
 Error codes.
*/
typedef NS_ENUM(NSInteger, AFErrorCode) {
    /// A network error occurred while loading ads from server.
    AFNetworkError,
    
    /// The request has timed out.
    AFTimedOutError,
    
    /// An ad server error occurred.
    AFServerError,
    
    /// An internal SDK error occurred.
    AFInternalError,
    
    /// The ad server returned invalid response.
    AFInvalidServerResponseError,
    
    /// The ad server returned valid response, but there was no ad to show.
    AFNoAdToShowError
};

extern NSValue *AFAdDimension(CGFloat width, CGFloat height);
extern NSValue *AFAdDimensionFromCGSize(CGSize size);
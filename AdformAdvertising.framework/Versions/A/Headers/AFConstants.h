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
extern CGFloat const AFAdViewAnimationDuration;

/**
 Default ad size for iPhone - 320x50.
 */
extern CGSize const AFDefaultIphoneAdSize;

/**
 Default ad size for iPad - 728x90.
 */
extern CGSize const AFDefaultIpadAdSize;

/**
 The size for a smart ad placement.
 */
extern CGSize const AFSmartAdSize;

/**
 A key that may be used to assign a different message for mraid.storePicture method confirmation alert.
 Usually this should be done to translate this message to application language.
 By default sdk uses this message: "Do you want to save this image to photos?".
 */
extern NSString * const kAFStorePictureAlertMessageKey;

/**
 A key that may be used to assign a different title for mraid.storePicture method confirmation alert save button.
 Usually this should be done to translate the title of the button to application language.
 By default sdk uses this title: "Save".
 */
extern NSString * const kAFStorePictureAlertSaveButtonTitleKey;

/**
 A key that may be used to assign a different title for mraid.storePicture method confirmation alert cancel button.
 Usually this should be done to translate the title of the button to application language.
 By default sdk uses this title: "Cancel".
 */
extern NSString * const kAFStorePictureAlertCancelButtonTitleKey;

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

/// Adform Advertising SDK error domain.
extern NSString *const kAFErrorDomain;

/**
 Error codes.
*/
typedef NS_ENUM(NSInteger, AFErrorCode) {
    /// A network error occurred while loading ads from server.
    AFNetworkError = 0,
    
    /// The request has timed out.
    AFTimedOutError = 1,
    
    /// An ad server error occurred.
    AFServerError = 2,
    
    /// An internal SDK error occurred.
    AFInternalError = 3,
    
    /// The ad server returned invalid response.
    AFInvalidServerResponseError = 4,
    
    /// The ad server returned valid response, but there was no ad to show.
    AFNoAdToShowError = 5,
    
    /// The sdk was unable to handle a VAST xml retreived from the ad server.
    AFInvalidVASTResponseError = 6
};

extern NSValue *AFAdDimensionFromCGSize(CGSize size);
extern NSValue *AFAdDimension(CGFloat width, CGFloat height);
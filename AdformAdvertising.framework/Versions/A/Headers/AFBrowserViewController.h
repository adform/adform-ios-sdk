//
//  AFBrowserViewController.h
//  AdformSDK
//
//  Created by Vladas on 07/07/14.
//  Copyright (c) 2014 adform. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Internal browser used for MRAID open function.
 It opens an add from URL in a new modal viewController with web browser.
 */
@interface AFBrowserViewController : UIViewController

/**
 The toolbar that presents navigation items.
 */
@property (nonatomic, strong, readonly) UIToolbar *toolBar;

/**
 A progress bar used to display page loading progress.
 */
@property (nonatomic, strong, readonly) UIProgressView *progressView;

/**
 Bar back navigtaion item.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *backItem;

/**
 Bar forward navigtaion item.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardItem;

/**
 Var reload page item.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *reloadItem;

/**
 Bar open page in safari item.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *openItem;

/**
 Bar close item.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *closeItem;

@end
NS_ASSUME_NONNULL_END

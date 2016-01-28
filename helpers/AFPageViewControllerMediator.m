//
//  AFPageViewControllerDatasource.m
//  AdformAdvertising
//
//  Created by Vladas Drejeris on 30/03/15.
//  Copyright (c) 2015 Adform. All rights reserved.
//

#import "AFPageViewControllerMediator.h"

/**
 A view controller used for ads display.
 */
@interface AFAdViewController : UIViewController

/**
 Page ad view is used to display ads.
 */
@property (nonatomic, strong, readonly) AFAdInterstitial *adView;

@end

@implementation AFAdViewController

- (void)setAdView:(AFAdInterstitial *)adView {
    
    _adView = adView;
    adView.frame = self.view.bounds;
    [self.view addSubview:_adView];
}

@end

@interface AFPageViewControllerMediator () <AFAdInlineDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    @private
    /// Master tag id.
    NSInteger _mid;
    /// Counter used to determine how many pages user has viewed.
    NSInteger _pageViews;
    /// Direction of the last page view controller navigation action.
    UIPageViewControllerNavigationDirection _lastNavigationDirection;
    /// A view controller used to display page ad view.
    AFAdViewController *_adViewController;
    /// View controllers displayed on page view controller on previous page.
    NSArray *_previousViewControllers;
    
    NSMutableArray *_tapGestureRecognisers;
}

/**
 Reference to original page view controllers delegate.
 */
@property (nonatomic, weak) id <UIPageViewControllerDelegate> originalDelegate;
/**
 Reference to original page view controllers datasource.
 */
@property (nonatomic, weak) id <UIPageViewControllerDataSource> originalDatasource;

@end

@implementation AFPageViewControllerMediator

- (instancetype)initWithMasterTagId:(NSInteger )mid {
    
    if (self = [super init]) {
        _mid = mid;
        _adFrequency = 3;
        _pageViews = 0;
        _debugMode = NO;
        _lastNavigationDirection = UIPageViewControllerNavigationDirectionForward;
    }
    
    return self;
}

- (instancetype)initWithMasterTagId:(NSInteger )mid
                        adFrequency:(NSInteger )adFrequency
                          debugMode:(BOOL)debugMode
                 pageViewController:(UIPageViewController *)pageViewController {
    
    if (self = [self initWithMasterTagId:mid]) {
        self.adFrequency = adFrequency;
        self.debugMode = debugMode;
        
        self.pageViewController = pageViewController;
    }
    
    return self;
}

- (instancetype)initWithMasterTagId:(NSInteger )mid
                          debugMode:(BOOL)debugMode
                 pageViewController:(UIPageViewController *)pageViewController {
    
    if (self = [self initWithMasterTagId:mid]) {
        self.debugMode = debugMode;
        
        self.pageViewController = pageViewController;
    }
    
    return self;
}

- (void)dealloc {
    
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
}

- (void)reset {
    
    // Reset page views conter.
    _pageViews = 0;
}

#pragma mark - Setters and getters

- (void)setPageViewController:(UIPageViewController *)pageViewController {
    
    self.originalDelegate = pageViewController.delegate;
    self.originalDatasource = pageViewController.dataSource;
    
    _pageViewController = pageViewController;
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    // When we initially set the page view controller we have to update page views counter equal to the number of pages displayed.
    if (_pageViewController.viewControllers.count > 0) {
        // In case of double page view controller at the begining it has only one view controller set, therfore we have to set the count manually.
        _pageViews = _pageViewController.spineLocation == UIPageViewControllerSpineLocationMid ? 2 : 1;
    }
    
    if (!_adViewController) {
        // If there is no ad view controller init one.
        [self initAdViewController];
    }
}

- (void)setDebugMode:(BOOL)debugMode {
    
    _debugMode = debugMode;
    
    _adViewController.adView.debugMode = debugMode;
}

- (UIViewController *)previousViewController {
    
    if (_lastNavigationDirection == UIPageViewControllerNavigationDirectionForward) {
        return [_previousViewControllers lastObject];
    } else {
        return [_previousViewControllers firstObject];
    }
}

#pragma mark - Ad injection

/**
 Checks if ad view should be displayed.
 */
- (BOOL)shouldShowAd {
    
    if (_pageViews >= _adFrequency) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldShowAfter:(UIViewController *)viewController {
    
    BOOL result;
    
    if ([viewController isKindOfClass:[AFAdViewController class]] || !_adViewController.adView.isLoaded) {
        result = NO;
    } else if ([self.delegate respondsToSelector:@selector(pageViewControllerMediator:shouldShowAdAfterViewController:)]) {
        result = [self.delegate pageViewControllerMediator:self shouldShowAdAfterViewController:viewController];
    } else {
        result = [self shouldShowAd];
    }
    
    return result;
}

- (BOOL)shouldShowBefore:(UIViewController *)viewController {
    
    BOOL result;
    
    if ([viewController isKindOfClass:[AFAdViewController class]] || !_adViewController.adView.isLoaded) {
        result = NO;
    } else if ([self.delegate respondsToSelector:@selector(pageViewControllerMediator:shouldShowAdBeforeViewController:)]) {
        result = [self.delegate pageViewControllerMediator:self shouldShowAdBeforeViewController:viewController];
    } else {
        result = [self shouldShowAd];
    }
    
    return result;
}

- (AFAdInterstitial *)createAdView:(UIViewController *)presentingViewController {
    
    AFAdInterstitial *adView = [[AFAdInterstitial alloc] initWithFrame:presentingViewController.view.bounds masterTagId:_mid presentingViewController:presentingViewController];
    adView.adTransitionStyle = AFAdTransitionStyleNone;
    adView.debugMode = self.debugMode;
    adView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    adView.translatesAutoresizingMaskIntoConstraints = YES;
    adView.delegate = self;
    
    return adView;
}

/**
 Creates a new AFAdViewController and sets it to _adViewController ivar.
 */
- (void)initAdViewController {
    
    // Create new ad view controller.
    _adViewController = [AFAdViewController new];
    
    [_adViewController setAdView:[self createAdView:self.pageViewController]];
    
    // Initiate ad loading.
    [_adViewController.adView loadAd];
}

/**
 Hides ad view.
 
 In case of single page view controller, it is animated with stadard page view controller animation.
 On double page view controller, a custom fade transition is used to hide the ad view.
 */
- (void)hideAdView:(void(^)())completion
{
    NSArray *viewControllers;
    BOOL animated = YES;
    
    //Check if we have a single o double page view controller.
    if (_pageViewController.spineLocation == UIPageViewControllerSpineLocationMid && _pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        viewControllers = [self viewControllerForDoublePageViewController];
        
        // In case of double page ad view controller we disable stadard animation.
        animated = NO;
        
    } else {
        viewControllers = [self viewControllerForSinglePageViewController];
    }

    _pageViews += viewControllers.count;
    
    [self setPagerViewControllers:viewControllers animated:animated completion:completion];
}

- (NSArray *)viewControllerForDoublePageViewController {
    
    UIViewController *currentController = [self currentViewController];
    UIViewController *nextViewController;
    NSArray *viewControllers;
    
    NSInteger indexOfAd = [self.pageViewController.viewControllers indexOfObject:_adViewController];
    if (indexOfAd == 0) {
        nextViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentController];
        if (!nextViewController) {
            nextViewController = [AFAdViewController new];
        }
        viewControllers = @[nextViewController, currentController];
    } else {
        nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentController];
        if (!nextViewController) {
            nextViewController = [AFAdViewController new];
        }
        viewControllers = @[currentController, nextViewController];
    }
    
    return viewControllers;
}

- (NSArray *)viewControllerForSinglePageViewController {
    
    UIViewController *previousController = _previousViewControllers[0];
    UIViewController *nextController;
    
    if (_lastNavigationDirection == UIPageViewControllerNavigationDirectionForward) {
        nextController = [self pageViewController:self.pageViewController viewControllerAfterViewController:previousController];
    } else {
        nextController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:previousController];
    }
    
    if (!nextController) {
        nextController = previousController;
    }
    
    return @[nextController];
}

- (void)setPagerViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)())completion
{
    if (!animated) {
        // If standard animation is disabled, use the custom CATransition.
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.3;
        [self.pageViewController.view.layer addAnimation:transition forKey:@"transition"];
    }
    
    // Finally set the new viewControllers.
    __weak typeof(self.pageViewController) _wpvc = self.pageViewController;
    UIPageViewControllerNavigationDirection dir = _lastNavigationDirection;
    [self.pageViewController setViewControllers:viewControllers
                                      direction:dir
                                       animated:animated
                                     completion:^(BOOL finished) {
                                         if (_wpvc.transitionStyle == UIPageViewControllerTransitionStyleScroll) {
                                             // Fix for a strange issue on iOS 7, when page view controller caches view controllers internally.
                                             // http://stackoverflow.com/questions/13633059/uipageviewcontroller-how-do-i-correctly-jump-to-a-specific-page-without-messing
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [_wpvc setViewControllers:viewControllers
                                                                 direction:dir
                                                                  animated:NO
                                                                completion:^(BOOL finished) {
                                                                    [self addTapGestures];
                                                                    completion();
                                                                }];
                                             });
                                         } else {
                                             [self addTapGestures];
                                             completion();
                                         }
                                     }];
}

/**
 Checks the page view controller 'viewControllers' property and returns the view controller which is not the ad view controller.
 
 @return UIViewController Currently displayed view controller which is not a subclass of AFAdViewController class.
 */
- (UIViewController *)currentViewController {
    
    for (UIViewController *viewController in _pageViewController.viewControllers) {
        if (![viewController isKindOfClass:[AFAdViewController class]]) {
            return viewController;
        }
    }
    
    return nil;
}

/**
 Checks if a view controller is currently inside the page view controller 'viewControllers' array property.
 
 @param aViewController A view controller to be checked.
 
 @return Bool value indicating if the view controller is in the page view controller 'viewControllers' array property.
 */
- (BOOL )isViewControllerVisible:(UIViewController *)aViewController {
    
    for (UIViewController *viewController in _pageViewController.viewControllers) {
        if ([aViewController isEqual:viewController]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - TapGesture handling

- (void)removeTapGestures {
    
    if (!_tapGestureRecognisers) {
        _tapGestureRecognisers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [_tapGestureRecognisers addObject:gesture];
            [self.pageViewController.view removeGestureRecognizer:gesture];
        }
    }
}

- (void)addTapGestures {
    
    if (_tapGestureRecognisers.count > 0) {
        for (UIGestureRecognizer *gesture in _tapGestureRecognisers) {
            [self.pageViewController.view addGestureRecognizer:gesture];
        }
    
        [_tapGestureRecognisers removeAllObjects];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    _lastNavigationDirection = UIPageViewControllerNavigationDirectionReverse;
    
    if ([self shouldShowBefore:viewController] && ![self isViewControllerVisible:_adViewController]) {
        _pageViews = 0;
        _adViewController.view.alpha = 1.0;
        return _adViewController;
    }
    
    if ([viewController isKindOfClass:[AFAdViewController class]]) {
        for (UIViewController *aViewController in [pageViewController viewControllers]) {
            if (![aViewController isKindOfClass:[AFAdViewController class]]) {
                viewController = aViewController;
                break;
            }
        }
        if ([viewController isKindOfClass:[AFAdViewController class]]) {
            for (UIViewController *aViewController in _previousViewControllers) {
                if (![aViewController isKindOfClass:[AFAdViewController class]]) {
                    viewController = aViewController;
                    break;
                }
            }
        }
    }
    UIViewController *nextViewController = [self.originalDatasource pageViewController:pageViewController viewControllerBeforeViewController:viewController];
    if (pageViewController.spineLocation == UIPageViewControllerSpineLocationMid && !nextViewController && ![self isViewControllerVisible:viewController]) {
        if (!_adViewController.view.window && _adViewController.adView.isLoaded) {
            nextViewController = _adViewController;
        } else {
            nextViewController = [AFAdViewController new];
        }
    }
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    _lastNavigationDirection = UIPageViewControllerNavigationDirectionForward;
    
    if ([self shouldShowAfter:viewController] && ![self isViewControllerVisible:_adViewController]) {
        _pageViews = 0;
        _adViewController.view.alpha = 1.0;
        return _adViewController;
    }
    
    if ([viewController isKindOfClass:[AFAdViewController class]]) {
        for (UIViewController *aViewController in [pageViewController viewControllers].reverseObjectEnumerator) {
            if (![aViewController isKindOfClass:[AFAdViewController class]]) {
                viewController = aViewController;
                break;
            }
        }
        if ([viewController isKindOfClass:[AFAdViewController class]]) {
            for (UIViewController *aViewController in _previousViewControllers.reverseObjectEnumerator) {
                if (![aViewController isKindOfClass:[AFAdViewController class]]) {
                    viewController = aViewController;
                    break;
                }
            }
        }
    }
    UIViewController *nextViewController = [self.originalDatasource pageViewController:pageViewController viewControllerAfterViewController:viewController];
    if (pageViewController.spineLocation == UIPageViewControllerSpineLocationMid && !nextViewController && ![self isViewControllerVisible:viewController]) {
        if (!_adViewController.view.window && _adViewController.adView.isLoaded) {
            nextViewController = _adViewController;
        } else {
            nextViewController = [AFAdViewController new];
        }
    }
    return nextViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    if ([self.originalDatasource respondsToSelector:@selector(presentationCountForPageViewController:)]) {
        return [self.originalDatasource presentationCountForPageViewController:pageViewController];
    } else {
        return 0;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    if ([self.originalDatasource respondsToSelector:@selector(presentationIndexForPageViewController:)]) {
        return [self.originalDatasource presentationIndexForPageViewController:pageViewController];
    } else {
        return 0;
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    if ([self.originalDelegate respondsToSelector:@selector(pageViewController:willTransitionToViewControllers:)]) {
        return [self.originalDelegate pageViewController:pageViewController willTransitionToViewControllers:pendingViewControllers];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if ([self.originalDelegate respondsToSelector:@selector(pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:)]) {
        [self.originalDelegate pageViewController:pageViewController didFinishAnimating:finished previousViewControllers:previousViewControllers transitionCompleted:completed];
    }
    
    if (finished && completed) {
        if (previousViewControllers.count > 1 || ![previousViewControllers.lastObject isKindOfClass:[AFAdViewController class]]) {
            _previousViewControllers = previousViewControllers;
        }
        
        BOOL adIsVisible = NO;
        
        for (UIViewController *viewController in pageViewController.viewControllers) {
            if (![viewController isKindOfClass:[AFAdViewController class]]) {
                _pageViews ++;
            } else {
                adIsVisible = YES;
            }
        }
        
        if (adIsVisible) {
            [self removeTapGestures];
        } else {
            [self addTapGestures];
        }
        
        if ([previousViewControllers containsObject:_adViewController] || ![_adViewController.adView isLoaded]) {
            [_adViewController.adView loadAd];
        }
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    if ([self.originalDelegate respondsToSelector:@selector(pageViewController:spineLocationForInterfaceOrientation:)]) {
        return [self.originalDelegate pageViewController:pageViewController spineLocationForInterfaceOrientation:orientation];
    } else {
        return [pageViewController spineLocation];
    }
}

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    
    if ([self.originalDelegate respondsToSelector:@selector(pageViewControllerSupportedInterfaceOrientations:)]) {
        return [self.originalDelegate pageViewControllerSupportedInterfaceOrientations:pageViewController];
    } else {
        return [[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:pageViewController.view.window];
    }
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController {
    
    if ([self.originalDelegate respondsToSelector:@selector(pageViewControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.originalDelegate pageViewControllerPreferredInterfaceOrientationForPresentation:pageViewController];
    } else {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
}

#pragma mark - AFAdInlineDelegate

- (void)adInlineDidLoadAd:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineDidLoadAd:)]) {
        [self.adViewDelegate adInlineDidLoadAd:adView];
    }
}

- (void)adInlineDidFailToLoadAd:(AFAdInline *)adView withError:(NSError *)error {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineDidFailToLoadAd:withError:)]) {
        [self.adViewDelegate adInlineDidFailToLoadAd:adView withError:error];
    }
}

- (void)adInlineWillShow:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillShow:)]) {
        [self.adViewDelegate adInlineWillShow:adView];
    }
}

- (void)adInlineWillHide:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillHide:)]) {
        [self.adViewDelegate adInlineWillHide:adView];
    }
}

- (void)adInlineWillPresentModalView:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillPresentModalView:)]) {
        [self.adViewDelegate adInlineWillPresentModalView:adView];
    }
}

- (void)adInlineWillDismissModalView:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillDismissModalView:)]) {
        [self.adViewDelegate adInlineWillDismissModalView:adView];
    }
}

- (void)adInlineWillOpenExternalBrowser:(AFAdInline *)adView {
    
    if ([self.adViewDelegate respondsToSelector:@selector(adInlineWillOpenExternalBrowser:)]) {
        [self.adViewDelegate adInlineWillOpenExternalBrowser:adView];
    }
}

@end

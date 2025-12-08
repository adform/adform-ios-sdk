//
//  AFPageViewControllerMediator.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import UIKit
import AdformAdvertising

protocol AFPageViewControllerMediating {
    var pageViewController: UIPageViewController { get set }
    var adViewDelegate: AFAdInlineDelegate? { get set }
    var adFrequency: Int { get set }
    func reset()
    func previousViewController() -> UIViewController?
}

@objc protocol AFPageViewControllerMediatorDelegate: AnyObject {
    @objc optional func pageViewController(mediator: AFPageViewControllerMediator, shouldShowAdAfterViewController viewController: UIViewController) -> Bool
    @objc optional func pageViewController(mediator: AFPageViewControllerMediator, shouldShowAdBeforeViewController viewController: UIViewController) -> Bool
}

final class AFPageViewControllerMediator: NSObject, AFPageViewControllerMediating {
    var pageViewController: UIPageViewController
    
    weak var adViewDelegate: AFAdInlineDelegate?
    
    weak var delegate: AFPageViewControllerMediatorDelegate?
    
    var adFrequency: Int = 3
    
    /// Master tag id.
    private var mid = 987063
    /// Counter used to determine how many pages user has viewed.
    private var pageViews = 0
    /// Direction of the last page view controller navigation action.
    private var lastNavigationDirection: UIPageViewController.NavigationDirection = .forward
    /// A view controller used to display page ad view.
    private var adViewController: AFAdViewController!
    /// View controllers displayed on page view controller on previous page.
    private var previousViewControllers: [UIViewController] = []
    private var tapGestureRecognisers: [UITapGestureRecognizer] = [UITapGestureRecognizer(), UITapGestureRecognizer(), UITapGestureRecognizer()]

    /// Reference to original page view controllers delegate.
    private weak var originalDelegate: UIPageViewControllerDelegate?
    /// Reference to original page view controllers datasource.
    private weak var originalDatasource: UIPageViewControllerDataSource?
    
    init(masterTagId: Int, adFrequency: Int, pageViewController: UIPageViewController) {
        self.mid = masterTagId
        self.adFrequency = adFrequency
        self.pageViewController = pageViewController
        super.init()
        configureAfterInit()
    }
    
    func configureAfterInit() {
        self.originalDelegate = pageViewController.delegate
        self.originalDatasource = pageViewController.dataSource
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if pageViewController.viewControllers?.count ?? 0 > 0 {
            pageViews = pageViewController.spineLocation == .mid ? 2 : 1
        }
        
        if (adViewController == nil) {
            // If there is no ad view controller init one.
            initAdViewController()
        }
    }
    
    func initAdViewController() {
        adViewController = AFAdViewController()
        
        adViewController.setAdView(createAdView(pageViewController))
        
        adViewController.adView?.loadAd()
    }
    
    func reset() {
        pageViews = 0
    }
    
    func previousViewController() -> UIViewController? {
        if lastNavigationDirection == .forward {
            return previousViewControllers.last
        } else {
            return previousViewControllers.first
        }
    }
    
    /**
     Hides ad view.
     
     In case of single page view controller, it is animated with stadard page view controller animation.
     On double page view controller, a custom fade transition is used to hide the ad view.
     */
    func hideAdView(_ completion: @escaping () -> Void) {
        var viewControllers: [UIViewController]
        var animated = true
        
        //Check if we have a single o double page view controller.
        if pageViewController.spineLocation == .mid && pageViewController.transitionStyle == .pageCurl {
            viewControllers = viewControllerForDoublePageViewController()
            
            // In case of double page ad view controller we disable stadard animation.
            animated = false
        } else {
            viewControllers = viewControllerForSinglePageViewController()
        }
        
        pageViews += viewControllers.count
        
        setPagerViewControllers(viewControllers, animated: animated, completion: completion)
    }
    
    func viewControllerForDoublePageViewController() -> [UIViewController] {

        let currentController = currentViewController()
        var nextViewController: UIViewController?
        var viewControllers: [UIViewController] = []

        let indexOfAd = pageViewController.viewControllers?.firstIndex(of: adViewController) ?? 0
        if indexOfAd == 0 {
            if let currentController = currentController {
                nextViewController = pageViewController(pageViewController, viewControllerBefore: currentController)
            }
            if nextViewController == nil {
                nextViewController = AFAdViewController()
            }
            viewControllers = [nextViewController, currentController].compactMap { $0 }
        } else {
            if let currentController = currentController {
                nextViewController = pageViewController(pageViewController, viewControllerAfter: currentController)
            }
            if nextViewController == nil {
                nextViewController = AFAdViewController()
            }
            viewControllers = [currentController, nextViewController].compactMap { $0 }
        }

        return viewControllers
    }
    
    func viewControllerForSinglePageViewController() -> [UIViewController] {

        let previousController = previousViewControllers[0]
        var nextController: UIViewController?
        
        if lastNavigationDirection == .forward {
            nextController = pageViewController(pageViewController, viewControllerAfter: previousController)
            
        } else {
            nextController = pageViewController(pageViewController, viewControllerBefore: previousController)
            
        }

        if nextController == nil {
            nextController = previousController
        }

        return [nextController].compactMap { $0 }
    }
    
    func setPagerViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        if !animated {
            // If standard animation is disabled, use the custom CATransition.
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            pageViewController.view.layer.add(transition, forKey: "transition")
        }

        // Finally set the new viewControllers.
        weak var _wpvc = pageViewController
        let dir = lastNavigationDirection
        pageViewController.setViewControllers(
            viewControllers,
            direction: dir,
            animated: animated) { [self] finished in
                if _wpvc?.transitionStyle == .scroll {
                    // Fix for a strange issue on iOS 7, when page view controller caches view controllers internally.
                    // http://stackoverflow.com/questions/13633059/uipageviewcontroller-how-do-i-correctly-jump-to-a-specific-page-without-messing
                    DispatchQueue.main.async(execute: { [self] in
                        _wpvc?.setViewControllers(
                            viewControllers,
                            direction: dir,
                            animated: false) { [self] finished in
                                addTapGestures()
                                completion()
                            }
                    })
                } else {
                    addTapGestures()
                    completion()
                }
            }
    }
    
    func shouldShowAd() -> Bool {
        if pageViews >= adFrequency {
            return true
        }
        return false
    }
    
    func shoudShow(before viewController: UIViewController) -> Bool {
        
        if viewController is AFAdViewController || !(adViewController.adView?.isLoaded ?? false) {
            return false
        } else if delegate?.pageViewController?(mediator: self, shouldShowAdAfterViewController: viewController) ?? false {
            return true
        } else {
            return shouldShowAd()
        }
    }
    
    func shouldShow(after viewController: UIViewController) -> Bool {
        if viewController is AFAdViewController || !(adViewController.adView?.isLoaded ?? false) {
            return false
        } else if delegate?.pageViewController?(mediator: self, shouldShowAdBeforeViewController: viewController) ?? false {
            return true
        } else {
            return shouldShowAd()
        }
    }

    func createAdView(_ presentingViewController: UIViewController) -> AFAdInterstitial {
        let adView = AFAdInterstitial(frame: presentingViewController.view.bounds, masterTagId: mid, presenting: presentingViewController)
        adView.adTransitionStyle = .none
        adView.autoresizingMask = ([.flexibleHeight, .flexibleWidth])
        adView.translatesAutoresizingMaskIntoConstraints = true
        adView.delegate = self
        return adView
    }
    
    /// Checks the page view controller 'viewControllers' property and returns the view controller which is not the ad view controller.
    /// - Returns: UIViewController Currently displayed view controller which is not a subclass of AFAdViewController class.
    func currentViewController() -> UIViewController? {
        for viewController in pageViewController.viewControllers ?? [] {
            if !(viewController is AFAdViewController) {
                return viewController
            }
        }
        return nil
    }

    /// Checks if a view controller is currently inside the page view controller 'viewControllers' array property.
    /// - Parameter aViewController: A view controller to be checked.
    /// - Returns: Bool value indicating if the view controller is in the page view controller 'viewControllers' array property.
    func isViewControllerVisible(_ aViewController: UIViewController?) -> Bool {

        for viewController in pageViewController.viewControllers ?? [] {
            if aViewController == viewController {
                return true
            }
        }

        return false
    }
    
    // MARK: - TapGesture handling
    
    func removeTapGestures() {
        for gesture in pageViewController.gestureRecognizers {
            if gesture is UITapGestureRecognizer {
                tapGestureRecognisers.append(gesture as! UITapGestureRecognizer)
                pageViewController.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func addTapGestures() {
        if tapGestureRecognisers.count > 0 {
            for gesture in tapGestureRecognisers {
                self.pageViewController.view.addGestureRecognizer(gesture)
            }
            tapGestureRecognisers.removeAll()
        }
    }
}

extension AFPageViewControllerMediator: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        lastNavigationDirection = .reverse
        if shoudShow(before: viewController) && !isViewControllerVisible(adViewController) {
            pageViews = 0
            adViewController.view.alpha = 1.0
            return adViewController
        }
        
        var theViewController: UIViewController?
        
        if viewController is AFAdViewController {
            for viewController in pageViewController.viewControllers ?? [] {
                if !(viewController is AFAdViewController) {
                    theViewController = viewController
                    break
                }
            }
            if viewController is AFAdViewController {
                for viewController in previousViewControllers {
                    if !(viewController is AFAdViewController) {
                        theViewController = viewController
                        break
                    }
                }
            }
        }
        
        var nextViewController = originalDatasource?.pageViewController(pageViewController, viewControllerBefore: theViewController ?? viewController)
        if pageViewController.spineLocation == .mid && nextViewController == nil && !isViewControllerVisible(viewController) {
            if (adViewController.view.window == nil) && adViewController.adView?.isLoaded ?? false {
                nextViewController = adViewController
            } else {
                nextViewController = AFAdViewController()
            }
        }
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        lastNavigationDirection = .forward
        
        if shouldShow(after: viewController) && !isViewControllerVisible(adViewController) {
            pageViews = 0
            adViewController.view.alpha = 1
            return adViewController
        }
        
        var theViewController: UIViewController?
        
        if viewController is AFAdViewController {
            for viewController in pageViewController.viewControllers?.reversed() ?? [] {
                if !(viewController is AFAdViewController) {
                    theViewController = viewController
                    break
                }
            }
            
            for viewController in previousViewControllers.reversed() {
                if !(viewController is AFAdViewController) {
                    theViewController = viewController
                    break
                }
            }
        }
        
        var nextViewController = originalDatasource?.pageViewController(pageViewController, viewControllerAfter: theViewController ?? viewController)
        if pageViewController.spineLocation == .mid && nextViewController == nil && !isViewControllerVisible(viewController) {
            if (adViewController.view.window == nil) && adViewController.adView?.isLoaded ?? false {
                nextViewController = adViewController
            } else {
                nextViewController = AFAdViewController()
            }
        }
        return nextViewController
    }
}

extension AFPageViewControllerMediator: AFAdInlineDelegate {
    func adInlineDidLoadAd(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineDidLoadAd?(adInline)
    }
    
    func adInlineDidFail(toLoadAd adInline: AFAdInline, withError error: Error) {
        adViewDelegate?.adInlineDidFail?(toLoadAd: adInline, withError: error)
    }
    
    func adInlineWillShow(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineWillShow?(adInline)
    }
    
    func adInlineWillHide(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineWillHide?(adInline)
    }
    
    func adInlineWillPresentModalView(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineWillPresentModalView?(adInline)
    }
    
    func adInlineWillDismissModalView(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineWillDismissModalView?(adInline)
    }
    
    func adInlineWillOpenExternalBrowser(_ adInline: AFAdInline) {
        adViewDelegate?.adInlineWillOpenExternalBrowser?(adInline)
    }
}

extension AFPageViewControllerMediator: AFAdInterstitialDelegate {
    func adInterstitial(_ adInterstitial: AFAdInterstitial, didReceiveCloseCommandWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        hideAdView {
            completionHandler(true)
        }
    }
}

extension AFPageViewControllerMediator: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        originalDelegate?.pageViewController?(pageViewController, willTransitionTo: pendingViewControllers)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        originalDelegate?.pageViewController?(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)

        if finished && completed {
            if previousViewControllers.count > 1 || !(previousViewControllers.last is AFAdViewController) {
                self.previousViewControllers = previousViewControllers
            }

            var adIsVisible = false

            for viewController in pageViewController.viewControllers ?? [] {
                if !(viewController is AFAdViewController) {
                    pageViews += 1
                } else {
                    adIsVisible = true
                }
            }

            if adIsVisible {
                removeTapGestures()
            } else {
                addTapGestures()
            }

            if previousViewControllers.contains(adViewController) || !(adViewController.adView?.isLoaded ?? false){
                adViewController.adView?.loadAd()
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        originalDelegate?.pageViewController?(pageViewController, spineLocationFor: orientation) ?? pageViewController.spineLocation
    }

    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        originalDelegate?.pageViewControllerSupportedInterfaceOrientations?(pageViewController) ?? UIApplication.shared.supportedInterfaceOrientations(for: pageViewController.view.window)
    }

    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        originalDelegate?.pageViewControllerPreferredInterfaceOrientationForPresentation?(pageViewController) ?? UIApplication.shared.statusBarOrientation
    }
    
    
}

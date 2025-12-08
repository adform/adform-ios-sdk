//
//  RootViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-04-22.
//

import UIKit

import AdformAdvertising

fileprivate let kMasterTag = 987063

class RootViewController: UIViewController, AFPageViewControllerMediatorDelegate, UIPageViewControllerDelegate {
    private var pageViewController: UIPageViewController?
    private var dataSource: DataSource = DataSource()
    private var mediator: AFPageViewControllerMediator?

    /// This is a default UIPageViewController implementation provided by "Page-Based Application" project template.

    override func viewDidLoad() {
        super.viewDidLoad()

        // This is your UIPageViewController implementation.
        // You can use any implementation you want, AFPageViewControllerMediator doesn't depend of implementation specifics.

        configurePageViewController()

        // To display ads we need to create and setup AFPageViewControllerMediator.
        mediator = AFPageViewControllerMediator(
            masterTagId: kMasterTag,
            adFrequency: 3,
            pageViewController: pageViewController!
        )
        mediator?.delegate = self
    }

    func configurePageViewController() {

        // Configure the page view controller and add it as a child view controller.
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageViewController?.delegate = self

        let startingViewController = dataSource.viewController(at: 0, storyboard: storyboard, previousController: nil)
        let viewControllers = [startingViewController]
        pageViewController?.setViewControllers(viewControllers.compactMap { $0 }, direction: .forward, animated: false)

        pageViewController?.dataSource = dataSource

        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = view.bounds
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        pageViewController?.view.frame = pageViewRect

        pageViewController?.didMove(toParent: self)

        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        view.gestureRecognizers = pageViewController?.gestureRecognizers
    }
    
    func pageViewController(mediator: AFPageViewControllerMediator, shouldShowAdAfterViewController viewController: UIViewController) -> Bool {
        
        return true
    }
    
    func pageViewController(mediator: AFPageViewControllerMediator, shouldShowAdBeforeViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        if orientation.isPortrait || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            
            let currentViewController = self.pageViewController?.viewControllers?[0]
            let viewControllers = [currentViewController]
            self.pageViewController?.setViewControllers(viewControllers.compactMap { $0 }, direction: .forward, animated: true)
            
            self.pageViewController?.isDoubleSided = false
            return .min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        var currentViewController = self.pageViewController?.viewControllers?[0] as? DataViewController
        if !(currentViewController != nil) {
            currentViewController = mediator?.previousViewController() as? DataViewController
        }
        var viewControllers: [UIViewController?] = []
        
        let indexOfCurrentViewController = dataSource.indexOf(currentViewController)
        if indexOfCurrentViewController == 0 || indexOfCurrentViewController ?? 0 % 2 == 0 {
            let nextViewController = dataSource.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController!)
            viewControllers = [currentViewController, nextViewController]
        } else {
            let previousViewController = dataSource.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController!)
            viewControllers = [previousViewController, currentViewController]
        }
        self.pageViewController?.setViewControllers(viewControllers.compactMap { $0 }, direction: .forward, animated: true)
        
        
        return .mid
    }
}

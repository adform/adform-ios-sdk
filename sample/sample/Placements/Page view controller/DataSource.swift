//
//  DataSource.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-04-22.
//

import Foundation
import UIKit

class DataSource: NSObject, UIPageViewControllerDataSource {
    private var pageData: [String] = DateFormatter().monthSymbols
    
    func indexOf(_ viewController: DataViewController?) -> Int? {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.firstIndex(of: viewController?.dataObject ?? "")
    }

    func viewController(at index: Int, storyboard: UIStoryboard?, previousController controller: DataViewController?) -> DataViewController? {
        guard index >= 0 else {
            return nil
        }
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as? DataViewController
        dataViewController?.previousIndex = indexOf(controller) ?? 0
        dataViewController?.dataObject = pageData[index]
        return dataViewController
    }
    
    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = indexOf(viewController as? DataViewController) {
            index -= 1
            return self.viewController(at: index, storyboard: UIApplication.shared.delegate?.window??.rootViewController?.storyboard, previousController: viewController as? DataViewController)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = indexOf(viewController as? DataViewController) {
            index += 1
            if index == pageData.count {
                return nil
            }
            return self.viewController(at: index, storyboard: UIApplication.shared.delegate?.window??.rootViewController?.storyboard, previousController: viewController as? DataViewController)
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pageData.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        let viewController = pageViewController.viewControllers?.last
        
        if let index = indexOf(viewController as? DataViewController) {
            return index
        }
        return 0
    }
}

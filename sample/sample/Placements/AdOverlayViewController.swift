//
//  AdOverlayViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import AdformAdvertising
import UIKit

fileprivate let kMasterTag = 987063

class AdOverlayViewController: UIViewController {
    // AFAdOverlay placement requires strong reference to it, otherwise the object will be released by arc before loading and displaying the ad.
    var adOverlay: AFAdOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Initialize AFAdOverlay object with master tag.
        adOverlay = AFAdOverlay(masterTagID: kMasterTag)

        // Display the ad at least 2 seconds after pushing the view controller.
        adOverlay?.show(from: self)
    }
}

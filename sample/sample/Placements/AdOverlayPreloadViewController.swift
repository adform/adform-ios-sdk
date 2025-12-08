//
//  AdOverlayPreloadViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import UIKit
import AdformAdvertising

class AdOverlayPreloadViewController: AdOverlayViewController {
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        adOverlay?.delegate = self

        indicatorView.startAnimating()

        // Initiate overlay ad loading
        adOverlay?.preloadAd()
    }

    @IBAction func showAd(_ sender: Any) {

        adOverlay?.show(from: self)

        showButton.isHidden = true
    }
}

extension AdOverlayPreloadViewController: AFAdOverlayDelegate {
    
    func adOverlayDidLoadAd(_ adOverlay: AFAdOverlay) {
        indicatorView.stopAnimating()
        showButton.isHidden = false
    }
}

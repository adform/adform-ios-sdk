//
//  AFAdViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import Foundation
import UIKit
import AdformAdvertising

class AFAdViewController: UIViewController {
    private(set) var adView: AFAdInterstitial?

    func setAdView(_ adView: AFAdInterstitial) {
        view.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        adView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        adView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.adView = adView
    }
}

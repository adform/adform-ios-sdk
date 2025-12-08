//
//  AdhesionViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import AdformAdvertising
import UIKit

class AdhesionViewController: UIViewController {
    @IBOutlet private weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelBottomConstraint: NSLayoutConstraint!
    
    var adPosition: AFAdPosition!
    private var adHesion: AFAdHesion?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Create and setup the ad view.
        adHesion = AFAdHesion(masterTagId: masterTag(), position: adPosition, presenting: self)
        //adHesion.videoSettings.closeButtonBehavior = .allways
        //adHesion.videoSettings.controlsStyle = .minimal

        if adPosition == .top {
            adHesion?.delegate = self
        } else {
            adHesion?.hidesOnSwipe = true
        }

        // This line of code enables multiple ad size support.
        adHesion?.areAditionalDimmensionsEnabled = true

        // Add it to view hierarchy and initiate ad loading.
        if let adHesion = adHesion {
            view.addSubview(adHesion)
        }
        adHesion?.loadAd()
    }

    func masterTag() -> Int {

        return 987051
    }

    override func updateViewConstraints() {
        if adHesion?.position == .top && (adHesion?.state == AFAdState.inShowTransition || adHesion?.state == AFAdState.visible) {
            labelTopConstraint.constant = adHesion?.adSize.height ?? 0.0
        } else {
            labelTopConstraint.constant = 8
        }

        super.updateViewConstraints()
    }
}

extension AdhesionViewController: AFAdInlineDelegate {
    func adInlineWillShow(_ adInline: AFAdInline) {
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: TimeInterval(AFAdViewAnimationDuration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    func adInlineWillHide(_ adInline: AFAdInline) {
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: TimeInterval(AFAdViewAnimationDuration)) {
            self.view.layoutIfNeeded()
        }
    }
}

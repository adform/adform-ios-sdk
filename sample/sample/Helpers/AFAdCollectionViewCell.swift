//
//  AFAdCollectionViewCell.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import UIKit
import AdformAdvertising.AFAdInterstitial

class AFAdCollectionViewCell: UICollectionViewCell {
    
    private var _adView: AFAdInterstitial?
    var adView: AFAdInterstitial? {
        get {
            _adView
        }
        set(adView) {

            _adView = adView
            _adView?.frame = contentView.bounds

            if let adView = adView {
                contentView.addSubview(adView)
            }
        }
    }
    
    func AFScrollDirectionIsPositive(_ direction: AFScrollingDirection) -> Bool {
        direction == .down || direction == .right
    }
}

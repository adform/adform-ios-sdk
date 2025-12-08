//
//  AdInlineResponsiveViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import UIKit
import AdformAdvertising

class AdInlineResponsiveViewController: AdInlineViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var verticalSpacing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        // Ad will be loaded in superclass.
        super.viewDidLoad()
        
        // We also need to update constraints to match labels width to screen size.
        updateConstraints()
        
        //Setup ad delegate.
        adInline.delegate = self
        
        // Move ad inline to scrollview.
        scrollView.addSubview(adInline)
        
        // Set adInline view constraints.
        setAdInlineConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func masterTag() -> Int {
        987051
    }
    
    func updateConstraints() {
        guard let topLabel = topLabel,
              let bottomLabel = bottomLabel else {
            return
        }
        
        view.addConstraint(
            NSLayoutConstraint(
                item: topLabel,
                attribute: .width,
                relatedBy: .lessThanOrEqual,
                toItem: view,
                attribute: .width,
                multiplier: 1.0,
                constant: -16)
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: bottomLabel,
                attribute: .width,
                relatedBy: .lessThanOrEqual,
                toItem: view,
                attribute: .width,
                multiplier: 1.0,
                constant: -16)
        )
    }
    
    func setAdInlineConstraints() {
        guard let adInline = adInline else {
            return
        }
        
        adInline.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(
            NSLayoutConstraint(
                item: adInline,
                attribute: .top,
                relatedBy: .equal,
                toItem: topLabel,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -8))
        scrollView.addConstraint(
            NSLayoutConstraint(
                item: adInline,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: scrollView,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0))
    }
}

extension AdInlineResponsiveViewController: AFAdInlineDelegate {
    func adInlineWillShow(_ adInline: AFAdInline) {
        // When ad is being displayed we should update label constraints to push it down and make place for the ad.
        // This transition is animated.
        UIView.animate(
            withDuration: TimeInterval(AFAdViewAnimationDuration),
            animations: { [self] in
                verticalSpacing.constant = (verticalSpacing.constant + adInline.adSize.height)
                scrollView.layoutIfNeeded()
            })
    }
    
    func adInlineWillHide(_ adInline: AFAdInline) {
        // When ad is being hidden we should update label constraints and put it back to its initial place.
        // This transition is animated.
        UIView.animate(
            withDuration: TimeInterval(AFAdViewAnimationDuration),
            animations: { [self] in
                verticalSpacing.constant = (verticalSpacing.constant - adInline.adSize.height)
                scrollView.layoutIfNeeded()
            })
    }
}

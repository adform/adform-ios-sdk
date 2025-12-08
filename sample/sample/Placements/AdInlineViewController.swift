//
//  AdInlineViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-25.
//

import UIKit
import AdformAdvertising

class AdInlineViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var adInline: AFAdInline!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create and setup ad inline view.
        adInline = AFAdInline(masterTagId: masterTag(), presenting: self)

        // This line of code enables multiple ad size support.
        adInline?.areAditionalDimmensionsEnabled = true

        // If you want to define the supported ad sizes uncomment this line of code too.
//        adInline.supportedDimmensions = [AFAdDimension(320, 50), AFAdDimension(320, 100), AFAdDimension(320, 150)];

        // Set custom position for the ad.
        adInline?.frame = CGRect(x: (view.frame.size.width - adInline.adSize.width) / 2, y: 300, width: adInline.adSize.width, height: adInline.adSize.height)

        // Add ad to view hierarchy and initiate loading.
        view.addSubview(adInline)
        adInline.loadAd()
    }
    
    func masterTag() -> Int {
        987051
    }
}

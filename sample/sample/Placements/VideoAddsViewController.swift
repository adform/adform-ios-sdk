//
//  VideoAddsViewController.swift
//  sample
//
//  Created by Jaroslav on 2022-05-30.
//

import UIKit
import AdformAdvertising

class VideoAddsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a new banner.
        let adHesion = AFAdHesion(masterTagId: 1203459,//987376,
                                  position: .top,
                                  presenting: self)
        
        // Define custom size of the banner.
        adHesion.adSize = CGSize(width: 320, height: 240)
        
        // To enable video fallback uncomment this line of code.
         adHesion.videoSettings.fallbackMasterTagId = fallbackMasterTag()
        
        // Setup video settings.
        adHesion.videoSettings.closeButtonBehavior = .allways
        adHesion.videoSettings.controlsStyle = .minimal
        
        // Add the ad view to view hierarchy.
        view.addSubview(adHesion)
        
        // Start loading.
        adHesion.loadAd()
    }
    

    func fallbackMasterTag() -> Int {
        return 142493
    }

}

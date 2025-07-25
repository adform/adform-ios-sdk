//
//  NativeAdsViewController.swift
//  sample
//
//  Created by Vladas Drejeris on 25/07/2025.
//  Copyright © 2025 adform. All rights reserved.
//

import UIKit
import AdformAdvertising
import AdformAdmobMediation
import GoogleMobileAds

class NativeAdsViewController: UIViewController {
    var adLoader: AdLoader?
    var nativeAdView: GADTSmallTemplateView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NativeAd"
        view.backgroundColor = .systemBackground
    }
    
    @IBAction private func openAdInspector(_ sender: UIButton) {
        MobileAds.shared.presentAdInspector(from: self) { error in
          // Error will be non-nil if there was an issue and the inspector was not displayed.
        }
    }
    
    @IBAction private func loadNativeAd(_ sender: UIButton) {
        let nativeAd = AFNative()
        let nativeRequest = AFNativeRequest()
        
        let nativeAsset = AFNativeRequestAsset()
        nativeAsset.rtbId = "0"
        nativeAsset.required = true
        nativeAsset.img = AFRequestImgAsset()
        nativeAsset.img?.heightMin = 166
        nativeAsset.img?.widthMin = 200
        nativeAsset.img?.type = 3
        nativeAd.request = nativeRequest
        
        let assets = [nativeAsset]
        nativeRequest.assets = assets
        
        let imp = AFImp()
        imp.rtbId = "1"
        imp.tagId = "1151535"
        imp.native = nativeAd
        
        let builder = AFOpenRTBRequestBuilder(
            rtbId: "322a0c8ff399a7",
            imps: [imp]
        )
        let request = builder.createOpenRtbRequest()
                
        AFOpenRTBBidLoader.requestAd(request) { response, error in
            print("Native ad response: \(String(describing: response)), error: \(String(describing: error))")
        }
    }
    
    @IBAction private func loadGoogleNativeAd(_ sender: UIButton) {
        adLoader = AdLoader(
            adUnitID: "ca-app-pub-3084463524165616/9352389562",
            rootViewController: self,
            adTypes: [.native],
            options: []
        )
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
    
    private func showNativeAd(nativeAd: NativeAd) {
        nativeAdView?.removeFromSuperview()
        
        guard
            let templateView = Bundle.main
                .loadNibNamed("GADTSmallTemplateView", owner: nil)?
                .first as? GADTSmallTemplateView
        else {
            return
        }
        
        templateView.translatesAutoresizingMaskIntoConstraints = false
        
        nativeAdView = templateView
        nativeAd.delegate = self
        
        view.addSubview(templateView)
        templateView.nativeAd = nativeAd
        templateView.addVerticalCenterConstraintToSuperview()
        templateView.addHorizontalConstraintsToSuperviewWidth()
    }
}

extension NativeAdsViewController: AdLoaderDelegate, NativeAdLoaderDelegate, NativeAdDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        showNativeAd(nativeAd: nativeAd)
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
        print("AdLoader didFailToReceiveAdWithError: \(String(describing: error))")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        
    }
}

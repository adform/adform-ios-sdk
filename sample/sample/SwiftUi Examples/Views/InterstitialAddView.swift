import SwiftUI
import UIKit
import AdformAdvertising

struct InterstitialAddView: UIViewRepresentable {
    
    var masterTag: Int

    func makeUIView(context: Context) -> AFAdInterstitial {
        guard let test = UIApplication.shared.rootViewController else {
            fatalError()
        }
        
        let adView = AFAdInterstitial(frame: test.view.bounds,
                                      masterTagId: 987063,
                                      presenting: test)

        // TODO: Move as a property of mediator.
        //adView.adSize = CGSize(width: 320, height: 480)
        adView.adTransitionStyle = .none
        adView.autoresizingMask = ([.flexibleHeight, .flexibleWidth])

        return adView
    }

    func updateUIView(_ uiView: AFAdInterstitial, context: Context) {
        uiView.tag = masterTag
        uiView.loadAd()
    }
}

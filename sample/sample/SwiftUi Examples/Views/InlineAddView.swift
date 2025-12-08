import SwiftUI
import AdformAdvertising

struct InlineAddView: UIViewRepresentable {
    
    var masterTag: Int = 987051

    func makeUIView(context: Context) -> AFAdInline {
        guard let presenter = UIApplication.shared.rootViewController else {
            fatalError()
        }
        let adInline = AFAdInline(masterTagId: masterTag, presenting: presenter)
        adInline.areAditionalDimmensionsEnabled = true

        // If you want to define the supported ad sizes uncomment this line of code too.
     //   adInline.supportedDimmensions = [AFAdDimension(320, 50),
       //                                  AFAdDimension(320, 100)
         //                                , AFAdDimension(320, 150)];

        // Set custom position for the ad.
        adInline.frame = CGRect(x: 0,
                                y: 0,
                                width: adInline.adSize.width,
                                height: adInline.adSize.height)
        adInline.setContentHuggingPriority(.required, for: .horizontal)
        adInline.setContentHuggingPriority(.required, for: .vertical)
        adInline.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        adInline.setContentCompressionResistancePriority(.required, for: .vertical)
        adInline.translatesAutoresizingMaskIntoConstraints = false

        return adInline
    }

    func updateUIView(_ uiView: AFAdInline, context: Context) {
        uiView.tag = masterTag
        uiView.loadAd()
    }
}

extension UIApplication {
  var currentKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }
      .first
  }

  var rootViewController: UIViewController? {
    currentKeyWindow?.rootViewController
  }

}
